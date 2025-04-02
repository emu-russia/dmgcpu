"""

DeepSeek prompt:

а напиши пожалуйста конвертер на питоне, который преобразует исходник Verilog в исходник на C++, при этом Verilog становится levelized C кодом (учитывает зависимости выполнения и распространения, а также циклы).
Симуляция на C должна базироваться на old_state и new_state, которые можно использовать для реализации edge (фрона сигнала).
Задержки распространения сигнала можно не учитывать при написании конвертера (пользователю допускается выполнение одного прогона несколько раз чтобы дождаться что схема перестала "звенеть" = устаканилась.

DeepL rus -> eng:

please write a python converter that converts Verilog source into C++ source, and Verilog becomes levelized C code (takes into account execution and propagation dependencies and cycles).
The C simulation should be based on old_state and new_state, which can be used to implement the edge (signal fronts).
Signal propagation delays can be ignored when writing the converter (the user is allowed to run one run several times to wait for the circuit to stop “ringing” = settle down)

"""

import re
import argparse
from collections import defaultdict, deque

class VerilogToCppConverter:
	def __init__(self):
		self.modules = {}
		self.current_module = None
		self.wires = set()
		self.inputs = set()
		self.outputs = set()
		self.inouts = set()  # For inout ports
		self.registers = set()
		self.assigns = []
		self.gates = []
		self.dependencies = defaultdict(set)
		self.dependents = defaultdict(set)
		self.sorted_gates = []
		self.edge_sensitive = set()

	def parse_verilog(self, filename):
		with open(filename, 'r') as f:
			content = f.read()

		# Remove comments
		content = re.sub(r'//.*?\n', '\n', content)
		content = re.sub(r'/\*.*?\*/', '', content, flags=re.DOTALL)

		# Parse modules
		modules = re.findall(r'module\s+(\w+)\s*\((.*?)\);\s*(.*?)\s*endmodule', content, re.DOTALL)
		for name, ports, body in modules:
			self.process_module(name, ports, body)

	def process_module(self, name, ports, body):
		self.current_module = name
		self.modules[name] = {
			'ports': ports,
			'body': body,
			'wires': set(),
			'inputs': set(),
			'outputs': set(),
			'inouts': set(),
			'registers': set(),
			'assigns': [],
			'gates': []
		}

		# Process ports
		port_list = [p.strip() for p in ports.split(',')]
		
		# Process declarations
		decl_pattern = r'(input|output|inout|wire|reg)\s+(?:\[.*?\]\s*)?([^;]+);'
		for decl in re.findall(decl_pattern, body):
			decl_type, vars = decl
			for var in vars.split(','):
				var = var.strip()
				if decl_type == 'input':
					self.modules[name]['inputs'].add(var)
				elif decl_type == 'output':
					self.modules[name]['outputs'].add(var)
				elif decl_type == 'inout':
					self.modules[name]['inouts'].add(var)
				elif decl_type == 'wire':
					self.modules[name]['wires'].add(var)
				elif decl_type == 'reg':
					self.modules[name]['registers'].add(var)

		# Process assignments
		for assign in re.findall(r'assign\s+([^=]+)\s*=\s*([^;]+);', body):
			lhs, rhs = assign
			lhs = lhs.strip()
			rhs = rhs.strip()
			self.modules[name]['assigns'].append((lhs, rhs))

		# Process instances (gates and flip-flops)
		gate_pattern = r'(\w+)\s+(\w+)\s*\((.*?)\);'
		for gate in re.findall(gate_pattern, body, re.DOTALL):
			gate_type, inst_name, connections = gate
			connections = [c.strip() for c in connections.split(',')]
			parsed_conns = {}
			for conn in connections:
				if '=' in conn:
					port, net = conn.split('=')
					parsed_conns[port.strip()] = net.strip()
				else:
					parsed_conns[None] = conn.strip()
			
			self.modules[name]['gates'].append({
				'type': gate_type,
				'instance': inst_name,
				'connections': parsed_conns
			})

	def build_dependency_graph(self, module_name):
		module = self.modules[module_name]
		self.wires = module['wires'].copy()
		self.inputs = module['inputs'].copy()
		self.outputs = module['outputs'].copy()
		self.inouts = module['inouts'].copy()
		self.registers = module['registers'].copy()
		self.assigns = module['assigns'].copy()
		self.gates = module['gates'].copy()
		
		# Build dependency graph
		for lhs, rhs in self.assigns:
			self._add_dependencies(lhs, rhs)
			
		for gate in self.gates:
			self._process_gate_dependencies(gate)
			
		# Topological sort
		self.topological_sort()

	def _add_dependencies(self, lhs, rhs):
		# Find all variables in right-hand side
		vars_in_rhs = re.findall(r'\b\w+\b', rhs)
		for var in vars_in_rhs:
			if var in self.wires or var in self.inputs or var in self.registers or var in self.inouts:
				self.dependencies[lhs].add(var)
				self.dependents[var].add(lhs)

	def _process_gate_dependencies(self, gate):
		gate_type = gate['type']
		conns = gate['connections']
		
		# Determine inputs and outputs for different gate types
		if gate_type.startswith('dmg_'):
			# Standard gate
			if gate_type in ['dmg_dffr', 'dmg_dffr_comp', 'dmg_dffrnq_comp']:
				# Flip-flop - edge sensitive
				clk = conns.get('clk', conns.get('ck'))
				if clk:
					self.edge_sensitive.add((gate_type, gate['instance'], clk))
				
				# Data input depends on d
				if 'd' in conns:
					self._add_dependencies(conns['q'], conns['d'])
					if 'nq' in conns:
						self._add_dependencies(conns['nq'], conns['d'])
			else:
				# Combinational logic
				outputs = []
				inputs = []
				
				if gate_type in ['dmg_not', 'dmg_not2', 'dmg_not3', 'dmg_not6', 'dmg_not10']:
					outputs = ['x']
					inputs = ['a']
				elif gate_type in ['dmg_and', 'dmg_or', 'dmg_nand', 'dmg_nor', 'dmg_xor', 'dmg_xnor']:
					outputs = ['x']
					inputs = ['a', 'b']
				elif gate_type in ['dmg_and3', 'dmg_or3', 'dmg_nand3', 'dmg_nor3']:
					outputs = ['x']
					inputs = ['a', 'b', 'c']
				elif gate_type in ['dmg_and4', 'dmg_or4', 'dmg_nand4', 'dmg_nor4']:
					outputs = ['x']
					inputs = ['a', 'b', 'c', 'd']
				elif gate_type in ['dmg_mux', 'dmg_muxi']:
					outputs = ['q']
					inputs = ['sel', 'd0', 'd1']
				elif gate_type in ['dmg_oan', 'dmg_oai']:
					outputs = ['x']
					inputs = ['a0', 'a1', 'b']
				elif gate_type in ['dmg_bufif0', 'dmg_bufif1']:
					outputs = ['x']
					inputs = ['a', 'ena'] if gate_type == 'dmg_bufif1' else ['a', 'n_ena']
				
				for out_port in outputs:
					if out_port in conns:
						out_net = conns[out_port]
						for in_port in inputs:
							if in_port in conns:
								in_net = conns[in_port]
								self._add_dependencies(out_net, in_net)

	def topological_sort(self):
		in_degree = {node: 0 for node in self.wires.union(self.inputs).union(self.outputs).union(self.inouts).union(self.registers)}
		
		for node in self.dependencies:
			in_degree[node] = len(self.dependencies[node])
			
		queue = deque([node for node in in_degree if in_degree[node] == 0])
		sorted_nodes = []
		
		while queue:
			node = queue.popleft()
			sorted_nodes.append(node)
			
			for dependent in self.dependents.get(node, set()):
				in_degree[dependent] -= 1
				if in_degree[dependent] == 0:
					queue.append(dependent)
					
		self.sorted_gates = sorted_nodes

	def generate_cpp(self, module_name, output_file):
		module = self.modules[module_name]
		self.build_dependency_graph(module_name)
		
		with open(output_file, 'w') as f:
			f.write(f'#include <cstdint>\n')
			f.write(f'#include <unordered_map>\n\n')
			f.write(f'class {module_name} {{\n')
			f.write('public:\n')
			
			# Declare states
			f.write('    struct State {\n')
			for wire in sorted(self.wires):
				f.write(f'        uint8_t {wire} = 0;\n')
			for reg in sorted(self.registers):
				f.write(f'        uint8_t {reg} = 0;\n')
			for port in sorted(self.inputs.union(self.outputs).union(self.inouts)):
				f.write(f'        uint8_t {port} = 0;\n')
			f.write('    };\n\n')
			
			f.write('    State old_state;\n')
			f.write('    State new_state;\n')
			f.write('    std::unordered_map<std::string, uint8_t*> external_buses;\n\n')
			
			# Constructor
			f.write(f'    {module_name}() {{\n')
			f.write('        // Initialize inout ports\n')
			for port in sorted(self.inouts):
				f.write(f'        external_buses["{port}"] = nullptr;\n')
			f.write('    }\n\n')
			
			# Methods for inout ports
			f.write('    // Methods for connecting external buses\n')
			for port in sorted(self.inouts):
				f.write(f'    void connect_{port}(uint8_t* bus) {{ external_buses["{port}"] = bus; }}\n')
			f.write('\n')
			
			# Update method
			f.write('    void update() {\n')
			f.write('        // Save previous state for edge detection\n')
			f.write('        old_state = new_state;\n\n')
			
			f.write('        // Read inout ports from external buses\n')
			for port in sorted(self.inouts):
				f.write(f'        if (external_buses["{port}"]) new_state.{port} = *external_buses["{port}"];\n')
			f.write('\n')
			
			f.write('        // Process edge-triggered flip-flops\n')
			for gate_type, inst_name, clk in self.edge_sensitive:
				f.write(f'        // {gate_type} {inst_name}\n')
				f.write(f'        if (new_state.{clk} == 1 && old_state.{clk} == 0) {{\n')
				f.write('            // Edge detected - update flip-flop\n')
				f.write('        }\n\n')
			
			f.write('        // Process combinational logic in correct order\n')
			for node in self.sorted_gates:
				if node in self.wires or node in self.outputs or node in self.inouts:
					for lhs, rhs in self.assigns:
						if lhs == node:
							f.write(f'        new_state.{lhs} = {self._convert_expression(rhs)};\n')
							break
					
					for gate in self.gates:
						conns = gate['connections']
						gate_type = gate['type']
						
						if gate_type.startswith('dmg_'):
							if 'x' in conns and conns['x'] == node:
								f.write(f'        // {gate_type} {gate["instance"]}\n')
								f.write(f'        new_state.{node} = {self._generate_gate_code(gate)};\n')
							elif 'q' in conns and conns['q'] == node:
								pass
			
			f.write('\n        // Write inout ports to external buses\n')
			for port in sorted(self.inouts):
				f.write(f'        if (external_buses["{port}"]) *external_buses["{port}"] = new_state.{port};\n')
			
			f.write('    }\n\n')
			
			# Getters and setters
			for port in sorted(self.inputs):
				f.write(f'    void set_{port}(uint8_t value) {{ new_state.{port} = value; }}\n')
			for port in sorted(self.outputs):
				f.write(f'    uint8_t get_{port}() const {{ return new_state.{port}; }}\n')
			for port in sorted(self.inouts):
				f.write(f'    uint8_t get_{port}() const {{ return new_state.{port}; }}\n')
				f.write(f'    void set_{port}(uint8_t value) {{ new_state.{port} = value; }}\n')
			
			f.write('};\n')

	def _convert_expression(self, expr):
		# Simple expression conversions
		expr = expr.replace('~', '!')
		expr = expr.replace('&', '&&')
		expr = expr.replace('|', '||')
		# Handle bus indices (e.g., bus[3:0])
		expr = re.sub(r'\[(\d+):(\d+)\]', r'_\1_\2', expr)
		return expr

	def _generate_gate_code(self, gate):
		gate_type = gate['type']
		conns = gate['connections']
		
		if gate_type in ['dmg_not', 'dmg_not2', 'dmg_not3', 'dmg_not6', 'dmg_not10']:
			return f'!new_state.{conns["a"]}'
		elif gate_type == 'dmg_and':
			return f'new_state.{conns["a"]} && new_state.{conns["b"]}'
		elif gate_type == 'dmg_or':
			return f'new_state.{conns["a"]} || new_state.{conns["b"]}'
		elif gate_type == 'dmg_nand':
			return f'!(new_state.{conns["a"]} && new_state.{conns["b"]})'
		elif gate_type == 'dmg_nor':
			return f'!(new_state.{conns["a"]} || new_state.{conns["b"]})'
		elif gate_type == 'dmg_xor':
			return f'new_state.{conns["a"]} ^ new_state.{conns["b"]}'
		elif gate_type == 'dmg_xnor':
			return f'!(new_state.{conns["a"]} ^ new_state.{conns["b"]})'
		elif gate_type == 'dmg_and3':
			return f'new_state.{conns["a"]} && new_state.{conns["b"]} && new_state.{conns["c"]}'
		elif gate_type == 'dmg_or3':
			return f'new_state.{conns["a"]} || new_state.{conns["b"]} || new_state.{conns["c"]}'
		elif gate_type == 'dmg_nand3':
			return f'!(new_state.{conns["a"]} && new_state.{conns["b"]} && new_state.{conns["c"]})'
		elif gate_type == 'dmg_nor3':
			return f'!(new_state.{conns["a"]} || new_state.{conns["b"]} || new_state.{conns["c"]})'
		elif gate_type == 'dmg_mux':
			return f'new_state.{conns["sel"]} ? new_state.{conns["d1"]} : new_state.{conns["d0"]}'
		elif gate_type == 'dmg_muxi':
			return f'new_state.{conns["sel"]} ? !new_state.{conns["d1"]} : !new_state.{conns["d0"]}'
		elif gate_type in ['dmg_oan', 'dmg_oai']:
			a0 = f'new_state.{conns["a0"]}'
			a1 = f'new_state.{conns["a1"]}'
			b = f'new_state.{conns["b"]}'
			if gate_type == 'dmg_oan':
				return f'({a0} || {a1}) && {b}'
			else:
				return f'!(({a0} || {a1}) && {b})'
		elif gate_type == 'dmg_bufif0':
			return f'(new_state.{conns["n_ena"]} == 0) ? new_state.{conns["a"]} : 0'
		elif gate_type == 'dmg_bufif1':
			return f'(new_state.{conns["ena"]} == 1) ? new_state.{conns["a"]} : 0'
		
		return '0; // Unsupported gate type'


def main():
	parser = argparse.ArgumentParser(description='Convert Verilog to levelized C++ code')
	parser.add_argument('-i', '--input', required=True, help='Input Verilog file (.v)')
	parser.add_argument('-o', '--output', required=True, help='Output C++ file (.cpp)')
	parser.add_argument('-m', '--module', required=True, help='Module name to convert')
	
	args = parser.parse_args()
	
	converter = VerilogToCppConverter()
	converter.parse_verilog(args.input)
	converter.generate_cpp(args.module, args.output)
	
	print(f'Successfully converted {args.input} to {args.output}')

if __name__ == '__main__':
	main()