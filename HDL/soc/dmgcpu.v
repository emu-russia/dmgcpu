module dmgcpu (  sck, md, d, p13, p12, p11, p10, sin, n_res, t2, t1, a, n_cs, n_rd, n_wr, phi, ck1, ck2, sout, p14, p15, so2, so1, s, fr, cpl, st, cp, cpg, ld0, ld1, n_mwr, ma, n_mrd, n_mcs, vin, n_nmi, m1);

	inout wire sck;
	inout wire [7:0] md;
	inout wire [7:0] d;
	inout wire p13;
	inout wire p12;
	inout wire p11;
	inout wire p10;
	inout wire sin;
	input wire n_res;
	input wire t2;
	input wire t1;
	inout wire [15:0] a;
	output wire n_cs;
	inout wire n_rd;
	inout wire n_wr;
	output wire phi;
	input wire ck1;
	output wire ck2;
	output wire sout;
	output wire p14;
	output wire p15;
	output wire so2;
	output wire so1;
	output wire s;
	output wire fr;
	output wire cpl;
	output wire st;
	output wire cp;
	output wire cpg;
	output wire ld0;
	output wire ld1;
	inout wire n_mwr;
	output wire [12:0] ma;
	inout wire n_mrd;
	inout wire n_mcs;
	input wire vin;
	input wire n_nmi;
	output wire m1;	

	// Wires

	wire w1;
	wire w2;
	wire w3;
	wire w4;
	wire w5;
	wire w6;
	wire w7;
	wire w8;
	wire w9;
	wire w10;
	wire w11;
	wire w12;
	wire w13;
	wire w14;
	wire w15;
	wire w16;
	wire w17;
	wire w18;
	wire w19;
	wire w20;
	wire w21;
	wire w22;
	wire w23;
	wire w24;
	wire w25;
	wire w26;
	wire w27;
	wire w28;
	wire w29;
	wire w30;
	wire w31;
	wire w32;
	wire w33;
	wire w34;
	wire w35;
	wire w36;
	wire w37;
	wire w38;
	wire w39;
	wire w40;
	wire w41;
	wire w42;
	wire w43;
	wire w44;
	wire w45;
	wire w46;
	wire w47;
	wire w48;
	wire w49;
	wire w50;
	wire w51;
	wire w52;
	wire w53;
	wire w54;
	wire w55;
	wire w56;
	wire w57;
	wire w58;
	wire w59;
	wire w60;
	wire w61;
	wire w62;
	wire w63;
	wire w64;
	wire w65;
	wire w66;
	wire w67;
	wire w68;
	wire w69;
	wire w70;
	wire w71;
	wire w72;
	wire w73;
	wire w74;
	wire w75;
	wire w76;
	wire w77;
	wire w78;
	wire w79;
	wire w80;
	wire w81;
	wire w82;
	wire w83;
	wire w84;
	wire w85;
	wire w86;
	wire w87;
	wire w88;
	wire w89;
	wire w90;
	wire w91;
	wire w92;
	wire w93;
	wire w94;
	wire w95;
	wire w96;
	wire w97;
	wire w98;
	wire w99;
	wire w100;
	wire w101;
	wire w102;
	wire w103;
	wire w104;
	wire w105;
	wire w106;
	wire w107;
	wire w108;
	wire w109;
	wire w110;
	wire w111;
	wire w112;
	wire w113;
	wire w114;
	wire w115;
	wire w116;
	wire w117;
	wire w118;
	wire w119;
	wire w120;
	wire w121;
	wire w122;
	wire w123;
	wire w124;
	wire w125;
	wire w126;
	wire w127;
	wire w128;
	wire w129;
	wire w130;
	wire w131;
	wire w132;
	wire w133;
	wire w134;
	wire w135;
	wire w136;
	wire w137;
	wire w138;
	wire w139;
	wire w140;
	wire w141;
	wire w142;
	wire w143;
	wire w144;
	wire w145;
	wire w146;
	wire w147;
	wire w148;
	wire w149;
	wire w150;
	wire w151;
	wire w152;
	wire w153;
	wire w154;
	wire w155;
	wire w156;
	wire w157;
	wire w158;
	wire w159;
	wire w160;
	wire w161;
	wire w162;
	wire w163;
	wire w164;
	wire w165;
	wire w166;
	wire w167;
	wire w168;
	wire w169;
	wire w170;
	wire w171;
	wire w172;
	wire w173;
	wire w174;
	wire w175;
	wire w176;
	wire w177;
	wire w178;
	wire w179;
	wire w180;
	wire w181;
	wire w182;
	wire w183;
	wire w184;
	wire w185;
	wire w186;
	wire w187;
	wire w188;
	wire w189;
	wire w190;
	wire w191;
	wire w192;
	wire w193;
	wire w194;
	wire w195;
	wire w196;
	wire w197;
	wire w198;
	wire w199;
	wire w200;
	wire w201;
	wire w202;
	wire w203;
	wire w204;
	wire w205;
	wire w206;
	wire w207;
	wire w208;
	wire w209;
	wire w210;
	wire w211;
	wire w212;
	wire w213;
	wire w214;
	wire w215;
	wire w216;
	wire w217;
	wire w218;
	wire w219;
	wire w220;
	wire w221;
	wire w222;
	wire w223;
	wire w224;
	wire w225;
	wire w226;
	wire w227;
	wire w228;
	wire w229;
	wire w230;
	wire w231;
	wire w232;
	wire w233;
	wire w234;
	wire w235;
	wire w236;
	wire w237;
	wire w238;
	wire w239;
	wire w240;
	wire w241;
	wire w242;
	wire w243;
	wire w244;
	wire w245;
	wire w246;
	wire w247;
	wire w248;
	wire w249;
	wire w250;
	wire w251;
	wire w252;
	wire w253;
	wire w254;
	wire w255;
	wire w256;
	wire w257;
	wire w258;
	wire w259;
	wire w260;
	wire w261;
	wire w262;
	wire w263;
	wire w264;
	wire w265;
	wire w266;
	wire w267;
	wire w268;
	wire w269;
	wire w270;
	wire w271;
	wire w272;
	wire w273;
	wire w274;
	wire w275;
	wire w276;
	wire w277;
	wire w278;
	wire w279;
	wire w280;
	wire w281;
	wire w282;
	wire w283;
	wire w284;
	wire w285;
	wire w286;
	wire w287;
	wire w288;
	wire w289;
	wire w290;
	wire w291;
	wire w292;
	wire w293;
	wire w294;
	wire w295;
	wire w296;
	wire w297;
	wire w298;
	wire w299;
	wire w300;
	wire w301;
	wire w302;
	wire w303;
	wire w304;
	wire w305;
	wire w306;
	wire w307;
	wire w308;
	wire w309;
	wire w310;
	wire w311;
	wire w312;
	wire w313;
	wire w314;
	wire w315;
	wire w316;
	wire w317;
	wire w318;
	wire w319;
	wire w320;
	wire w321;
	wire w322;
	wire w323;
	wire w324;
	wire w325;
	wire w326;
	wire w327;
	wire w328;
	wire w329;
	wire w330;
	wire w331;
	wire w332;
	wire w333;
	wire w334;
	wire w335;
	wire w336;
	wire w337;
	wire w338;
	wire w339;
	wire w340;
	wire w341;
	wire w342;
	wire w343;
	wire w344;
	wire w345;
	wire w346;
	wire w347;
	wire w348;
	wire w349;
	wire w350;
	wire w351;
	wire w352;
	wire w353;
	wire w354;
	wire w355;
	wire w356;
	wire w357;
	wire w358;
	wire w359;
	wire w360;
	wire w361;
	wire w362;
	wire w363;
	wire w364;
	wire w365;
	wire w366;
	wire w367;
	wire w368;
	wire w369;
	wire w370;
	wire w371;
	wire w372;
	wire w373;
	wire w374;
	wire w375;
	wire w376;
	wire w377;
	wire w378;
	wire w379;
	wire w380;
	wire w381;
	wire w382;
	wire w383;
	wire w384;
	wire w385;
	wire w386;
	wire w387;
	wire w388;
	wire w389;
	wire w390;
	wire w391;
	wire w392;
	wire w393;
	wire w394;
	wire w395;
	wire w396;
	wire w397;
	wire w398;
	wire w399;
	wire w400;
	wire w401;
	wire w402;
	wire w403;
	wire w404;
	wire w405;
	wire w406;
	wire w407;
	wire w408;
	wire w409;
	wire w410;
	wire w411;
	wire w412;
	wire w413;
	wire w414;
	wire w415;
	wire w416;
	wire w417;
	wire w418;
	wire w419;
	wire w420;
	wire w421;
	wire w422;
	wire w423;
	wire w424;
	wire w425;
	wire w426;
	wire w427;
	wire w428;
	wire w429;
	wire w430;
	wire w431;
	wire w432;
	wire w433;
	wire w434;
	wire w435;
	wire w436;
	wire w437;
	wire w438;
	wire w439;
	wire w440;
	wire w441;
	wire w442;
	wire w443;
	wire w444;
	wire w445;
	wire w446;
	wire w447;
	wire w448;
	wire w449;
	wire w450;
	wire w451;
	wire w452;
	wire w453;
	wire w454;
	wire w455;
	wire w456;
	wire w457;
	wire w458;
	wire w459;
	wire w460;
	wire w461;
	wire w462;
	wire w463;
	wire w464;
	wire w465;
	wire w466;
	wire w467;
	wire w468;
	wire w469;
	wire w470;
	wire w471;
	wire w472;
	wire w473;
	wire w474;
	wire w475;
	wire w476;
	wire w477;
	wire w478;
	wire w479;
	wire w480;
	wire w481;
	wire w482;
	wire w483;
	wire w484;
	wire w485;
	wire w486;
	wire w487;
	wire w488;
	wire w489;
	wire w490;
	wire w491;
	wire w492;
	wire w493;
	wire w494;
	wire w495;
	wire w496;
	wire w497;
	wire w498;
	wire w499;
	wire w500;
	wire w501;
	wire w502;
	wire w503;
	wire w504;
	wire w505;
	wire w506;
	wire w507;
	wire w508;
	wire w509;
	wire w510;
	wire w511;
	wire w512;
	wire w513;
	wire w514;
	wire w515;
	wire w516;
	wire w517;
	wire w518;
	wire w519;
	wire w520;
	wire w521;
	wire w522;
	wire w523;
	wire w524;
	wire w525;
	wire w526;

	assign sck = w1;
	assign md[0] = w2;
	assign md[1] = w3;
	assign md[2] = w4;
	assign md[3] = w5;
	assign md[4] = w6;
	assign md[5] = w7;
	assign md[6] = w8;
	assign md[7] = w9;
	assign d[7] = w10;
	assign d[6] = w11;
	assign d[5] = w12;
	assign d[4] = w13;
	assign d[3] = w14;
	assign d[2] = w15;
	assign d[1] = w16;
	assign d[0] = w17;
	assign p13 = w18;
	assign p12 = w19;
	assign p11 = w20;
	assign p10 = w21;
	assign sin = w22;
	assign w23 = n_res;
	assign w24 = t2;
	assign w25 = t1;
	assign a[15] = w26;
	assign a[14] = w27;
	assign a[13] = w28;
	assign a[12] = w29;
	assign a[11] = w30;
	assign a[10] = w31;
	assign a[9] = w32;
	assign a[8] = w33;
	assign a[7] = w34;
	assign a[6] = w35;
	assign a[5] = w36;
	assign a[4] = w37;
	assign a[3] = w38;
	assign a[2] = w39;
	assign a[1] = w40;
	assign a[0] = w41;
	assign n_cs = w42;
	assign n_rd = w43;
	assign n_wr = w44;
	assign phi = w45;
	assign w46 = ck1;
	assign ck2 = w47;
	assign sout = w48;
	assign p14 = w49;
	assign p15 = w50;
	assign so2 = w51;
	assign so1 = w52;
	assign s = w53;
	assign fr = w54;
	assign cpl = w55;
	assign st = w56;
	assign cp = w57;
	assign cpg = w58;
	assign ld0 = w59;
	assign ld1 = w60;
	assign n_mwr = w61;
	assign ma[8] = w62;
	assign ma[9] = w63;
	assign ma[11] = w64;
	assign n_mrd = w65;
	assign ma[10] = w66;
	assign n_mcs = w67;
	assign ma[12] = w68;
	assign ma[7] = w69;
	assign ma[6] = w70;
	assign ma[5] = w71;
	assign ma[4] = w72;
	assign ma[3] = w73;
	assign ma[2] = w74;
	assign ma[1] = w75;
	assign ma[0] = w76;
	assign w77 = vin;
	assign w525 = n_nmi;
	assign m1 = w526;

	// Instances

	IOBUF_B pad_md7 (.DRV_LOW(w289), .n_INPUT(w288), .n_ENA_PU(w290), .n_DRV_HIGH(w287), .PAD_IO(w9) );
	IOBUF_B pad_md6 (.DRV_LOW(w293), .n_INPUT(w292), .n_ENA_PU(w290), .n_DRV_HIGH(w291), .PAD_IO(w8) );
	IOBUF_B pad_md5 (.DRV_LOW(w296), .n_INPUT(w295), .n_ENA_PU(w290), .n_DRV_HIGH(w294), .PAD_IO(w7) );
	IOBUF_B pad_md4 (.DRV_LOW(w299), .n_INPUT(w298), .n_ENA_PU(w290), .n_DRV_HIGH(w297), .PAD_IO(w6) );
	IOBUF_B pad_md3 (.DRV_LOW(w302), .n_INPUT(w301), .n_ENA_PU(w290), .n_DRV_HIGH(w300), .PAD_IO(w5) );
	IOBUF_B pad_md2 (.DRV_LOW(w305), .n_INPUT(w304), .n_ENA_PU(w290), .n_DRV_HIGH(w303), .PAD_IO(w4) );
	IOBUF_B pad_md1 (.DRV_LOW(w308), .n_INPUT(w307), .n_ENA_PU(w290), .n_DRV_HIGH(w306), .PAD_IO(w3) );
	IOBUF_B pad_md0 (.DRV_LOW(w310), .n_INPUT(w311), .n_ENA_PU(w290), .n_DRV_HIGH(w309), .PAD_IO(w2) );
	IOBUF_C pad_sck (.n_DRV_HIGH(w254), .n_ENA_PU(w255), .DRV_LOW(w257), .n_INPUT(w256), .PAD_IO(w1) );
	IOBUF_B pad_d7 (.DRV_LOW(w314), .n_INPUT(w313), .n_ENA_PU(w315), .n_DRV_HIGH(w312), .PAD_IO(w10) );
	IOBUF_B pad_d6 (.DRV_LOW(w318), .n_INPUT(w317), .n_ENA_PU(w315), .n_DRV_HIGH(w316), .PAD_IO(w11) );
	IOBUF_B pad_d5 (.PAD_IO(w12), .DRV_LOW(w321), .n_DRV_HIGH(w319), .n_ENA_PU(w315), .n_INPUT(w320) );
	IOBUF_B pad_d4 (.PAD_IO(w13), .DRV_LOW(w324), .n_DRV_HIGH(w322), .n_ENA_PU(w315), .n_INPUT(w323) );
	IOBUF_B pad_d3 (.PAD_IO(w14), .DRV_LOW(w327), .n_DRV_HIGH(w325), .n_ENA_PU(w315), .n_INPUT(w326) );
	IOBUF_B pad_d2 (.PAD_IO(w15), .DRV_LOW(w330), .n_DRV_HIGH(w328), .n_ENA_PU(w315), .n_INPUT(w329) );
	IOBUF_B pad_d1 (.PAD_IO(w16), .DRV_LOW(w333), .n_DRV_HIGH(w331), .n_ENA_PU(w315), .n_INPUT(w332) );
	IOBUF_B pad_d0 (.PAD_IO(w17), .DRV_LOW(w336), .n_DRV_HIGH(w334), .n_ENA_PU(w315), .n_INPUT(w335) );
	IOBUF_B pad_sin (.PAD_IO(w22), .DRV_LOW(w253), .n_ENA_PU(w251), .n_DRV_HIGH(w250), .n_INPUT(w252) );
	IOBUF_B pad_p10 (.PAD_IO(w21), .DRV_LOW(w261), .n_ENA_PU(w259), .n_DRV_HIGH(w258), .n_INPUT(w260) );
	IOBUF_B pad_p11 (.PAD_IO(w20), .DRV_LOW(w264), .n_ENA_PU(w259), .n_DRV_HIGH(w262), .n_INPUT(w263) );
	IOBUF_B pad_p12 (.PAD_IO(w19), .DRV_LOW(w267), .n_ENA_PU(w259), .n_DRV_HIGH(w265), .n_INPUT(w266) );
	IOBUF_B pad_p13 (.PAD_IO(w18), .DRV_LOW(w270), .n_ENA_PU(w259), .n_DRV_HIGH(w268), .n_INPUT(w269) );
	IBUF_A pad_t1 (.n_INPUT(w247), .PAD_IN(w25) );
	IBUF_A pad_t2 (.n_INPUT(w248), .PAD_IN(w24) );
	IBUF_A pad_nres (.n_INPUT(w79), .PAD_IN(w23) );
	IOBUF_A pad_a15 (.PAD_IO(w26), .n_DRV_HIGH(w192), .DRV_LOW(w194), .n_INPUT(w193) );
	IOBUF_A pad_a14 (.PAD_IO(w27), .n_DRV_HIGH(w195), .DRV_LOW(w197), .n_INPUT(w196) );
	IOBUF_A pad_a13 (.PAD_IO(w28), .n_DRV_HIGH(w198), .DRV_LOW(w200), .n_INPUT(w199) );
	IOBUF_A pad_a12 (.PAD_IO(w29), .n_DRV_HIGH(w201), .DRV_LOW(w203), .n_INPUT(w202) );
	IOBUF_A pad_a11 (.PAD_IO(w30), .n_DRV_HIGH(w204), .DRV_LOW(w206), .n_INPUT(w205) );
	IOBUF_A pad_a10 (.PAD_IO(w31), .n_DRV_HIGH(w207), .DRV_LOW(w209), .n_INPUT(w208) );
	IOBUF_A pad_a9 (.PAD_IO(w32), .n_DRV_HIGH(w210), .DRV_LOW(w212), .n_INPUT(w211) );
	IOBUF_A pad_a8 (.PAD_IO(w33), .n_DRV_HIGH(w213), .DRV_LOW(w215), .n_INPUT(w214) );
	IOBUF_A pad_a7 (.PAD_IO(w34), .n_DRV_HIGH(w216), .DRV_LOW(w218), .n_INPUT(w217) );
	IOBUF_A pad_a6 (.PAD_IO(w35), .n_DRV_HIGH(w219), .DRV_LOW(w221), .n_INPUT(w220) );
	IOBUF_A pad_a5 (.PAD_IO(w36), .n_DRV_HIGH(w222), .DRV_LOW(w224), .n_INPUT(w223) );
	IOBUF_A pad_a4 (.PAD_IO(w37), .n_DRV_HIGH(w225), .DRV_LOW(w227), .n_INPUT(w226) );
	IOBUF_A pad_a3 (.PAD_IO(w38), .n_DRV_HIGH(w228), .DRV_LOW(w230), .n_INPUT(w229) );
	IOBUF_A pad_a2 (.PAD_IO(w39), .n_DRV_HIGH(w231), .DRV_LOW(w233), .n_INPUT(w232) );
	IOBUF_A pad_a1 (.PAD_IO(w40), .n_DRV_HIGH(w234), .DRV_LOW(w236), .n_INPUT(w235) );
	IOBUF_A pad_a0 (.PAD_IO(w41), .n_DRV_HIGH(w237), .DRV_LOW(w239), .n_INPUT(w238) );
	IOBUF_A pad_nrd (.PAD_IO(w43), .n_DRV_HIGH(w241), .DRV_LOW(w243), .n_INPUT(w242) );
	IOBUF_A pad_nwr (.PAD_IO(w44), .n_DRV_HIGH(w244), .DRV_LOW(w246), .n_INPUT(w245) );
	IOBUF_A pad_nmcs (.PAD_IO(w67), .DRV_LOW(w286), .n_DRV_HIGH(w284), .n_INPUT(w285) );
	IOBUF_A pad_nmrd (.PAD_IO(w65), .DRV_LOW(w283), .n_DRV_HIGH(w281), .n_INPUT(w282) );
	IOBUF_A pad_nmwr (.PAD_IO(w61), .DRV_LOW(w280), .n_DRV_HIGH(w278), .n_INPUT(w279) );
	OBUF_A pad_s (.n_OUTPUT(w164), .PAD_OUT(w53) );
	OBUF_A pad_fr (.n_OUTPUT(w163), .PAD_OUT(w54) );
	OBUF_A pad_cpl (.n_OUTPUT(w162), .PAD_OUT(w55) );
	OBUF_A pad_st (.n_OUTPUT(w161), .PAD_OUT(w56) );
	OBUF_A pad_cp (.n_OUTPUT(w160), .PAD_OUT(w57) );
	OBUF_A pad_cpg (.n_OUTPUT(w159), .PAD_OUT(w58) );
	OBUF_A pad_m1 (.n_OUTPUT(w100), .PAD_OUT(w526) );
	OBUF_A pad_ld0 (.n_OUTPUT(w158), .PAD_OUT(w59) );
	OBUF_A pad_ld1 (.n_OUTPUT(w157), .PAD_OUT(w60) );
	OBUF_A pad_ma12 (.n_OUTPUT(w144), .PAD_OUT(w68) );
	OBUF_A pad_ma11 (.n_OUTPUT(w146), .PAD_OUT(w64) );
	OBUF_A pad_ma10 (.n_OUTPUT(w145), .PAD_OUT(w66) );
	OBUF_A pad_ma9 (.n_OUTPUT(w148), .PAD_OUT(w63) );
	OBUF_A pad_ma8 (.n_OUTPUT(w147), .PAD_OUT(w62) );
	OBUF_A pad_ma7 (.n_OUTPUT(w151), .PAD_OUT(w69) );
	OBUF_A pad_ma6 (.n_OUTPUT(w149), .PAD_OUT(w70) );
	OBUF_A pad_ma5 (.n_OUTPUT(w150), .PAD_OUT(w71) );
	OBUF_A pad_ma4 (.n_OUTPUT(w154), .PAD_OUT(w72) );
	OBUF_A pad_ma3 (.n_OUTPUT(w152), .PAD_OUT(w73) );
	OBUF_A pad_ma2 (.n_OUTPUT(w153), .PAD_OUT(w74) );
	OBUF_A pad_ma1 (.n_OUTPUT(w155), .PAD_OUT(w75) );
	OBUF_A pad_ma0 (.n_OUTPUT(w156), .PAD_OUT(w76) );
	AOBUFFER pad_so1 (.VOUT(w277), .PAD_OUT(w52) );
	AOBUFFER pad_so2 (.VOUT(w276), .PAD_OUT(w51) );
	OBUF_B pad_p15 (.n_DRV_HIGH(w273), .DRV_LOW(w274), .PAD_OUT(w50) );
	OBUF_B pad_p14 (.DRV_LOW(w272), .n_DRV_HIGH(w271), .PAD_OUT(w49) );
	IBUF_B pad_nnmi (.PAD_IN(w525), .n_INPUT(w98) );
	OBUF_A pad_ncs (.PAD_OUT(w42), .n_OUTPUT(w240) );
	OBUF_A pad_phi (.PAD_OUT(w45), .n_OUTPUT(w84) );
	OSC ck1_ck2 (.ENA(w87), .n_CLK(w78), .CK_IN(w46), .CK_OUT(w47) );
	OBUF_A pad_sout (.PAD_OUT(w48), .n_OUTPUT(w249) );
	AIBUFFER pad_vin (.VIN(w275), .PAD_IN(w77) );

// Formatted by DeepSeek. Prompt:
// The Verilog below does not specify ports correctly, e.g. `.a[0] (wire)`. Rework the text so that all buses are "collapsed" as for example `.a ({w1,w2,w2,...})` (lsb last). Source code to be redone:  <source verilog>
/*
	PPU1 ppu1 (.a[0](w101), .a[1](w102), .d[7](w103), .d[6](w104), .d[5](w105), .d[4](w106), .d[3](w107), .d[2](w108), .d[1](w109), .d[0](w110), .a[2](w111), .a[3](w112), .a[4](w113), .a[5](w114), .a[6](w115), .a[7](w116), .a[8](w117), .a[9](w118), .a[10](w119), .a[11](w120), .a[12](w121), .n_ma[12](w144), .n_ma[10](w145), .n_ma[11](w146), .n_ma[8](w147), .n_ma[9](w148), .n_ma[6](w149), .n_ma[5](w150), .n_ma[7](w151), .n_ma[3](w152), .n_ma[2](w153), .n_ma[4](w154), .n_ma[1](w155), .n_ma[0](w156), .n_lcd_ld1(w157), .n_lcd_ld0(w158), .n_lcd_cpg(w159), .n_lcd_cp(w160), .n_lcd_st(w161), .n_lcd_cpl(w162), .n_lcd_fr(w163), .n_lcd_s(w164), .CONST0(w259), .n_dma_phi(w337), .ppu_rd(w355), .ppu_wr(w356), .ppu_clk(w365), .vram_to_oam(w366), .ffxx(w395), .n_ppu_hard_reset(w396), .ff46(w397), .nma[9](w398), .fexx(w399), .nma[0](w400), .ff43(w401), .nma[4](w402), .nma[12](w403), .nma[6](w404), .nma[5](w405), .ff42(w406), .nma[11](w407), .nma[10](w408), .sprite_x_flip(w409), .nma[3](w410), .nma[2](w411), .sprite_x_match(w412), .bp_sel(w413), .ppu_mode3(w450), .md[2](w451), .md[5](w452), .md[1](w453), .md[7](w454), .md[0](w455), .md[6](w456), .md[3](w457), .md[4](w458), .v[7](w460), .FF43_D1(w461), .FF43_D0(w462), .n_ppu_clk(w463), .FF43_D2(w464), .h[3](w465), .ppu_mode2(w466), .h[0](w467), .h[1](w468), .vbl(w469), .stop_oam_eval(w470), .obj_color(w471), .vclk2(w472), .h_restart(w473), .obj_prio_ck(w474), .obj_prio(w475), .n_ppu_reset(w476), .h[6](w477), .n_dma_phi2_latched(w483), .nma[7](w484), .nma[8](w485), .nma[1](w486), .v[5](w487), .h[7](w488), .FF40_D3(w489), .FF40_D2(w490), .in_window(w491), .h[5](w492), .v[3](w493), .v[6](w494), .v[4](w495), .v[0](w496), .h[4](w497), .v[2](w498), .h[2](w499), .v[1](w500), .FF40_D1(w501), .sp_bp_cys(w505), .tm_bp_cys(w506), .n_sp_bp_mrd(w507), .n_tm_bp_cys(w508), .arb_fexx_ffxx(w509), .ppu_int_stat(w512), .ppu_int_vbl(w513), .oam_mode3_bl_pch(w517), .bp_cy(w518), .tm_cy(w519), .oam_mode3_nrd(w520), .ppu1_ma0(w521), .oam_rd_ck(w522), .oam_xattr_latch_cck(w523), .oam_addr_ck(w524) );
	PPU2 ppu2 (.cclk(w80), .clk6(w89), .n_reset2(w93), .a[0](w101), .a[1](w102), .d[7](w103), .d[6](w104), .d[5](w105), .d[4](w106), .d[3](w107), .d[2](w108), .d[1](w109), .d[0](w110), .a[2](w111), .a[3](w112), .a[4](w113), .a[5](w114), .a[6](w115), .a[7](w116), .n_oamb[0](w165), .n_oamb[1](w166), .n_oamb[2](w167), .n_oamb[3](w168), .n_oamb[4](w169), .n_oamb[5](w170), .n_oamb[6](w171), .n_oamb[7](w172), .oam_bl_pch(w173), .oa[1](w174), .oa[2](w175), .oa[3](w176), .oa[4](w177), .oa[5](w178), .oa[6](w179), .oa[7](w180), .n_oam_rd(w181), .n_oamb_wr(w182), .n_oama_wr(w183), .n_oama[0](w184), .n_oama[1](w185), .n_oama[2](w186), .n_oama[3](w187), .n_oama[4](w188), .n_oama[5](w189), .n_oama[6](w190), .n_oama[7](w191), .CONST0(w259), .n_dma_phi(w337), .dma_a[0](w338), .dma_a[4](w339), .dma_a[2](w340), .dma_a[6](w341), .dma_a[10](w342), .dma_a[1](w343), .dma_a[5](w344), .dma_a[11](w345), .dma_a[3](w346), .dma_a[7](w347), .dma_a[8](w348), .dma_a[12](w349), .dma_a[9](w350), .dma_run(w351), .soc_wr(w352), .soc_rd(w353), .ppu_rd(w355), .ppu_wr(w356), .ppu_clk(w365), .vram_to_oam(w366), .n_ppu_hard_reset(w396), .nma[9](w398), .fexx(w399), .nma[0](w400), .ff43(w401), .nma[4](w402), .nma[12](w403), .nma[6](w404), .nma[5](w405), .ff42(w406), .nma[11](w407), .nma[10](w408), .sprite_x_flip(w409), .nma[3](w410), .nma[2](w411), .sprite_x_match(w412), .bp_sel(w413), .ppu_mode3(w450), .md[2](w451), .md[5](w452), .md[1](w453), .md[7](w454), .md[0](w455), .md[6](w456), .md[3](w457), .md[4](w458), .oam_din[1](w459), .v[7](w460), .FF43_D1(w461), .FF43_D0(w462), .n_ppu_clk(w463), .FF43_D2(w464), .h[3](w465), .ppu_mode2(w466), .h[0](w467), .h[1](w468), .vbl(w469), .stop_oam_eval(w470), .obj_color(w471), .vclk2(w472), .h_restart(w473), .obj_prio_ck(w474), .obj_prio(w475), .n_ppu_reset(w476), .h[6](w477), .oam_din[0](w478), .oam_din[3](w479), .oam_to_vram(w480), .oam_din[6](w481), .oam_din[4](w482), .n_dma_phi2_latched(w483), .nma[7](w484), .nma[8](w485), .nma[1](w486), .v[5](w487), .h[7](w488), .FF40_D3(w489), .FF40_D2(w490), .in_window(w491), .h[5](w492), .v[3](w493), .v[6](w494), .v[4](w495), .v[0](w496), .h[4](w497), .v[2](w498), .h[2](w499), .v[1](w500), .FF40_D1(w501), .dma_addr_ext(w502), .oam_din[5](w503), .oam_din[7](w504), .sp_bp_cys(w505), .cpu_vram_oam_rd(w510), .oam_dma_wr(w511), .clk6_delay(w514), .oam_din[2](w515), .oam_mode3_bl_pch(w517), .bp_cy(w518), .tm_cy(w519), .oam_mode3_nrd(w520), .ma0(w521), .oam_rd_ck(w522), .oam_xattr_latch_cck(w523), .oam_addr_ck(w524) );
	OAM oam (.n_oamb[0](w165), .n_oamb[1](w166), .n_oamb[2](w167), .n_oamb[3](w168), .n_oamb[4](w169), .n_oamb[5](w170), .n_oamb[6](w171), .n_oamb[7](w172), .oam_bl_pch(w173), .oa[1](w174), .oa[2](w175), .oa[3](w176), .oa[4](w177), .oa[5](w178), .oa[6](w179), .oa[7](w180), .n_oam_rd(w181), .n_oamb_wr(w182), .n_oama_wr(w183), .n_oama[0](w184), .n_oama[1](w185), .n_oama[2](w186), .n_oama[3](w187), .n_oama[4](w188), .n_oama[5](w189), .n_oama[6](w190), .n_oama[7](w191) );
	HRAM hram (.clk7(w90), .a[0](w101), .a[1](w102), .d[7](w103), .d[6](w104), .d[5](w105), .d[4](w106), .d[3](w107), .d[2](w108), .d[1](w109), .d[0](w110), .a[2](w111), .a[3](w112), .a[4](w113), .a[5](w114), .a[6](w115), .a[7](w116), .soc_wr(w352), .soc_rd(w353), .ffxx(w395) );
	DAC dac (.vin_analog(w275), .so2_analog(w276), .so1_analog(w277), .n_ch1_amp_en(w414), .n_ch2_amp_en(w415), .n_ch3_amp_en(w416), .n_ch4_amp_en(w417), .ch1_out[0](w418), .ch1_out[1](w419), .ch1_out[2](w420), .ch1_out[3](w421), .ch2_out[0](w422), .ch2_out[1](w423), .ch2_out[2](w424), .ch2_out[3](w425), .ch3_out[0](w426), .ch3_out[1](w427), .ch3_out[2](w428), .ch3_out[3](w429), .ch4_out[0](w430), .ch4_out[1](w431), .ch4_out[2](w432), .ch4_out[3](w433), .r_vin_en(w434), .rmixer[0](w435), .rmixer[1](w436), .rmixer[2](w437), .rmixer[3](w438), .l_vin_en(w439), .lmixer[0](w440), .lmixer[1](w441), .lmixer[2](w442), .lmixer[3](w443), .n_rvolume[2](w444), .n_rvolume[1](w445), .n_rvolume[0](w446), .n_lvolume[2](w447), .n_lvolume[1](w448), .n_lvolume[0](w449) );
	BootROM bootrom (.a[0](w101), .a[1](w102), .d[7](w103), .d[6](w104), .d[5](w105), .d[4](w106), .d[3](w107), .d[2](w108), .d[1](w109), .d[0](w110), .a[2](w111), .a[3](w112), .a[4](w113), .a[5](w114), .a[6](w115), .a[7](w116), .a[8](w117), .a[9](w118), .a[10](w119), .a[11](w120), .a[12](w121), .a[13](w122), .a[14](w123), .a[15](w124), .from_g1_YULA(w516) );
	Ser ser (.n_reset2(w93), .d[5](w105), .d[6](w104), .d[7](w103), .d[4](w106), .d[3](w107), .d[2](w108), .d[1](w109), .d[0](w110), .n_sin(w252), .sck_dir(w255), .n_sck(w256), .int_serial(w357), .sc_read(w358), .sb_read(w359), .sc_write(w360), .n_sb_write(w361), .lfo_16384Hz(w362), .ser_out(w363), .serial_tick(w364) );
	ClkGen clkgen (.n_clk_in(w78), .reset(w79), .cclk(w80), .clk1(w81), .clk2(w82), .clk3(w83), .clk4(w84), .osc_stable(w85), .clk_ena(w86), .osc_ena(w87), .clk5(w88), .clk6(w89), .clk7(w90), .clk8(w91), .clk9(w92), .n_reset2(w93), .sync_reset(w94), .cpu_mreq(w95), .ext_cs_en(w96), .cpu_wr_sync(w97), .cpu_wr(w140), .test_1(w369), .n_test_reset(w374) );
	MMIO mmio (.reset(w79), .clk2(w82), .clk4(w84), .osc_stable(w85), .clk_ena(w86), .osc_ena(w87), .clk6(w89), .clk9(w92), .n_reset2(w93), .cpu_wr_sync(w97), .cpu_m1(w99), .n_cpu_m1(w100), .a[0](w101), .a[1](w102), .d[7](w103), .d[6](w104), .d[5](w105), .d[4](w106), .d[3](w107), .d[2](w108), .d[1](w109), .d[0](w110), .a[2](w111), .a[3](w112), .a[4](w113), .a[5](w114), .a[6](w115), .a[7](w116), .a[8](w117), .a[9](w118), .a[10](w119), .a[11](w120), .a[12](w121), .a[13](w122), .a[14](w123), .cpu_irq_trig[4](w128), .cpu_irq_ack[4](w129), .cpu_irq_trig[3](w130), .cpu_irq_ack[3](w131), .cpu_irq_trig[2](w132), .cpu_irq_ack[2](w133), .cpu_irq_trig[1](w134), .cpu_irq_ack[1](w135), .cpu_irq_trig[0](w136), .cpu_irq_ack[0](w137), .cpu_rd(w139), .cpu_wr(w140), .n_DRV_HIGH_a[14](w195), .n_INPUT_a[14](w196), .DRV_LOW_a[14](w197), .n_DRV_HIGH_a[13](w198), .n_INPUT_a[13](w199), .DRV_LOW_a[13](w200), .n_DRV_HIGH_a[12](w201), .n_INPUT_a[12](w202), .DRV_LOW_a[12](w203), .n_DRV_HIGH_a[11](w204), .n_INPUT_a[11](w205), .DRV_LOW_a[11](w206), .n_DRV_HIGH_a[10](w207), .n_INPUT_a[10](w208), .DRV_LOW_a[10](w209), .n_DRV_HIGH_a[9](w210), .n_INPUT_a[9](w211), .DRV_LOW_a[9](w212), .n_DRV_HIGH_a[8](w213), .n_INPUT_a[8](w214), .DRV_LOW_a[8](w215), .n_DRV_HIGH_nrd(w241), .n_INPUT_nrd(w242), .DRV_LOW_nrd(w243), .n_DRV_HIGH_nwr(w244), .n_INPUT_nwr(w245), .DRV_LOW_nwr(w246), .n_t1_frompad(w247), .n_t2_frompad(w248), .CONST0(w259), .n_ena_pu_db(w315), .n_dma_phi(w337), .dma_a[0](w338), .dma_a[4](w339), .dma_a[2](w340), .dma_a[6](w341), .dma_a[10](w342), .dma_a[1](w343), .dma_a[5](w344), .dma_a[11](w345), .dma_a[3](w346), .dma_a[7](w347), .dma_a[8](w348), .dma_a[12](w349), .dma_a[9](w350), .dma_run(w351), .soc_wr(w352), .soc_rd(w353), .lfo_512Hz(w354), .ppu_rd(w355), .ppu_wr(w356), .int_serial(w357), .sc_read(w358), .sb_read(w359), .sc_write(w360), .n_sb_write(w361), .lfo_16384Hz(w362), .ppu_clk(w365), .vram_to_oam(w366), .dma_a[15](w367), .non_vram_mreq(w368), .test_1(w369), .test_2(w370), .n_extdb_to_intdb(w371), .n_dblatch_to_intdb(w372), .n_intdb_to_extdb(w373), .n_test_reset(w374), .n_ext_addr_en(w375), .addr_latch(w392), .int_jp(w393), .FF60_D1(w394), .ffxx(w395), .n_ppu_hard_reset(w396), .ff46(w397), .dma_addr_ext(w502), .cpu_vram_oam_rd(w510), .oam_dma_wr(w511), .ppu_int_stat(w512), .ppu_int_vbl(w513), .clk6_delay(w514) );
	SM83Core core (.RESET(w79), .CLK1(w81), .CLK2(w82), .CLK3(w83), .CLK4(w84), .OSC_STABLE(w85), .CLK_ENA(w86), .OSC_ENA(w87), .CLK5(w88), .CLK6(w89), .CLK7(w90), .CLK8(w91), .CLK9(w92), .SYNC_RESET(w94), .CPU_MREQ(w95), .NMI(w98), .M1(w99), .A[0](w101), .A[1](w102), .D[7](w103), .D[6](w104), .D[5](w105), .D[4](w106), .D[3](w107), .D[2](w108), .D[1](w109), .D[0](w110), .A[2](w111), .A[3](w112), .A[4](w113), .A[5](w114), .A[6](w115), .A[7](w116), .A[8](w117), .A[9](w118), .A[10](w119), .A[11](w120), .A[12](w121), .A[13](w122), .A[14](w123), .A[15](w124), .CPU_IRQ_TRIG[7](1'b0), .CPU_IRQ_TRIG[6](1'b0), .CPU_IRQ_TRIG[5](1'b0), .CPU_IRQ_TRIG[4](w128), .CPU_IRQ_ACK[4](w129), .CPU_IRQ_TRIG[3](w130), .CPU_IRQ_ACK[3](w131), .CPU_IRQ_TRIG[2](w132), .CPU_IRQ_ACK[2](w133), .CPU_IRQ_TRIG[1](w134), .CPU_IRQ_ACK[1](w135), .CPU_IRQ_TRIG[0](w136), .CPU_IRQ_ACK[0](w137), .WAKE(w138), .RD(w139), .WR(w140), .MMIO_REQ(w141), .IPL_REQ(w142), .BUS_DISABLE(w369), .IPL_DISABLE(w370) );
	Arbiter arb (.clk2(w82), .n_reset2(w93), .cpu_mreq(w95), .ext_cs_en(w96), .cpu_wr_sync(w97), .a[0](w101), .a[1](w102), .d[7](w103), .d[6](w104), .d[5](w105), .d[4](w106), .d[3](w107), .d[2](w108), .d[1](w109), .d[0](w110), .a[2](w111), .a[3](w112), .a[4](w113), .a[5](w114), .a[6](w115), .a[7](w116), .a[8](w117), .a[9](w118), .a[10](w119), .a[11](w120), .a[12](w121), .a[13](w122), .a[14](w123), .a[15](w124), .cpu_wr(w140), .mmio_sel(w141), .boot_sel(w142), .n_DRV_HIGH_a[15](w192), .n_INPUT_a[15](w193), .DRV_LOW_a[15](w194), .n_cs_topad(w240), .CONST0(w259), .n_DRV_HIGH_nmwr(w278), .n_mwr(w279), .DRV_LOW_nmwr(w280), .n_DRV_HIGH_nmrd(w281), .n_mrd(w282), .DRV_LOW_nmrd(w283), .n_DRV_HIGH_nmcs(w284), .n_mcs(w285), .DRV_LOW_nmcs(w286), .n_DRV_HIGH_md[7](w287), .n_md_frompad[7](w288), .DRV_LOW_md[7](w289), .n_md_ena_pu(w290), .n_DRV_HIGH_md[6](w291), .n_md_frompad[6](w292), .DRV_LOW_md[6](w293), .n_DRV_HIGH_md[5](w294), .n_md_frompad[5](w295), .DRV_LOW_md[5](w296), .n_DRV_HIGH_md[4](w297), .n_md_frompad[4](w298), .DRV_LOW_md[4](w299), .n_DRV_HIGH_md[3](w300), .n_md_frompad[3](w301), .DRV_LOW_md[3](w302), .n_DRV_HIGH_md[2](w303), .n_md_frompad[2](w304), .DRV_LOW_md[2](w305), .n_DRV_HIGH_md[1](w306), .n_md_frompad[1](w307), .DRV_LOW_md[1](w308), .n_DRV_HIGH_md[0](w309), .DRV_LOW_md[0](w310), .n_md_frompad[0](w311), .n_DRV_HIGH_d[7](w312), .n_db_frompad[7](w313), .DRV_LOW_d[7](w314), .n_ena_pu_db(w315), .n_DRV_HIGH_d[6](w316), .n_db_frompad[6](w317), .DRV_LOW_d[6](w318), .n_DRV_HIGH_d[5](w319), .n_db_frompad[5](w320), .DRV_LOW_d[5](w321), .n_DRV_HIGH_d[4](w322), .n_db_frompad[4](w323), .DRV_LOW_d[4](w324), .n_DRV_HIGH_d[3](w325), .n_db_frompad[3](w326), .DRV_LOW_d[3](w327), .n_DRV_HIGH_d[2](w328), .n_db_frompad[2](w329), .DRV_LOW_d[2](w330), .n_DRV_HIGH_d[1](w331), .n_db_frompad[1](w332), .DRV_LOW_d[1](w333), .n_DRV_HIGH_d[0](w334), .n_db_frompad[0](w335), .DRV_LOW_d[0](w336), .soc_wr(w352), .soc_rd(w353), .vram_to_oam(w366), .dma_a[15](w367), .non_vram_mreq(w368), .test_1(w369), .n_extdb_to_intdb(w371), .n_dblatch_to_intdb(w372), .n_intdb_to_extdb(w373), .ffxx(w395), .n_ppu_hard_reset(w396), .ppu_mode3(w450), .md[2](w451), .md[5](w452), .md[1](w453), .md[7](w454), .md[0](w455), .md[6](w456), .md[3](w457), .md[4](w458), .oam_din[1](w459), .oam_din[0](w478), .oam_din[3](w479), .oam_to_vram(w480), .oam_din[6](w481), .oam_din[4](w482), .dma_addr_ext(w502), .oam_din[5](w503), .oam_din[7](w504), .sp_bp_cys(w505), .tm_bp_cys(w506), .n_sp_bp_mrd(w507), .n_tm_bp_cys(w508), .arb_fexx_ffxx(w509), .cpu_vram_oam_rd(w510), .oam_din[2](w515) );
	APU apu (.cclk(w80), .clk2(w82), .clk4(w84), .clk6(w89), .clk7(w90), .clk9(w92), .n_reset2(w93), .a[0](w101), .a[1](w102), .d[7](w103), .d[6](w104), .d[5](w105), .d[4](w106), .d[3](w107), .d[2](w108), .d[1](w109), .d[0](w110), .a[2](w111), .a[3](w112), .a[4](w113), .a[5](w114), .a[6](w115), .a[7](w116), .cpu_wakeup(w138), .n_DRV_HIGH_a[7](w216), .n_INPUT_a[7](w217), .DRV_LOW_a[7](w218), .n_DRV_HIGH_a[6](w219), .n_INPUT_a[6](w220), .DRV_LOW_a[6](w221), .n_DRV_HIGH_a[5](w222), .n_INPUT_a[5](w223), .DRV_LOW_a[5](w224), .n_DRV_HIGH_a[4](w225), .n_INPUT_a[4](w226), .DRV_LOW_a[4](w227), .n_DRV_HIGH_a[3](w228), .n_INPUT_a[3](w229), .DRV_LOW_a[3](w230), .n_DRV_HIGH_a[2](w231), .n_INPUT_a[2](w232), .DRV_LOW_a[2](w233), .n_DRV_HIGH_a[1](w234), .n_INPUT_a[1](w235), .DRV_LOW_a[1](w236), .n_DRV_HIGH_a[0](w237), .n_INPUT_a[0](w238), .DRV_LOW_a[0](w239), .n_sout_topad(w249), .n_DRV_HIGH_sin(w250), .n_ENA_PU_sin(w251), .DRV_LOW_sin(w253), .n_DRV_HIGH_sck(w254), .sck_dir(w255), .DRV_LOW_sck(w257), .n_DRV_HIGH_p10(w258), .CONST0(w259), .n_p10(w260), .DRV_LOW_p10(w261), .n_DRV_HIGH_p11(w262), .n_p11(w263), .DRV_LOW_p11(w264), .n_DRV_HIGH_p12(w265), .n_p12(w266), .DRV_LOW_p12(w267), .n_DRV_HIGH_p13(w268), .n_p13(w269), .DRV_LOW_p13(w270), .n_DRV_HIGH_p14(w271), .DRV_LOW_p14(w272), .n_DRV_HIGH_p15(w273), .DRV_LOW_p15(w274), .dma_a[0](w338), .dma_a[4](w339), .dma_a[2](w340), .dma_a[6](w341), .dma_a[1](w343), .dma_a[5](w344), .dma_a[3](w346), .dma_a[7](w347), .soc_wr(w352), .soc_rd(w353), .lfo_512Hz(w354), .ser_out(w363), .serial_tick(w364), .test_1(w369), .test_2(w370), .n_ext_addr_en(w375), .ch3_active(w376), .wave_a[2](w377), .wave_a[3](w378), .wave_a[0](w379), .wave_a[1](w380), .wave_rd[0](w381), .wave_rd[1](w382), .wave_rd[2](w383), .wave_rd[3](w384), .wave_rd[4](w385), .wave_rd[5](w386), .wave_rd[6](w387), .wave_rd[7](w388), .n_wave_wr(w389), .wave_bl_pch(w390), .n_wave_rd(w391), .addr_latch(w392), .int_jp(w393), .FF60_D1(w394), .ffxx(w395), .n_ch1_amp_en(w414), .n_ch2_amp_en(w415), .n_ch3_amp_en(w416), .n_ch4_amp_en(w417), .ch1_out[0](w418), .ch1_out[1](w419), .ch1_out[2](w420), .ch1_out[3](w421), .ch2_out[0](w422), .ch2_out[1](w423), .ch2_out[2](w424), .ch2_out[3](w425), .ch3_out[0](w426), .ch3_out[1](w427), .ch3_out[2](w428), .ch3_out[3](w429), .ch4_out[0](w430), .ch4_out[1](w431), .ch4_out[2](w432), .ch4_out[3](w433), .r_vin_en(w434), .rmixer[0](w435), .rmixer[1](w436), .rmixer[2](w437), .rmixer[3](w438), .l_vin_en(w439), .lmixer[0](w440), .lmixer[1](w441), .lmixer[2](w442), .lmixer[3](w443), .n_rvolume[2](w444), .n_rvolume[1](w445), .n_rvolume[0](w446), .n_lvolume[2](w447), .n_lvolume[1](w448), .n_lvolume[0](w449), .dma_addr_ext(w502) );
	WaveRAM waveram (.d[7](w103), .d[6](w104), .d[5](w105), .d[4](w106), .d[3](w107), .d[2](w108), .d[1](w109), .d[0](w110), .active(w376), .a[2](w377), .a[3](w378), .a[0](w379), .a[1](w380), .dout[0](w381), .dout[1](w382), .dout[2](w383), .dout[3](w384), .dout[4](w385), .dout[5](w386), .dout[6](w387), .dout[7](w388), .n_wr(w389), .bl_pch(w390), .n_rd(w391) );
*/

	dmg_and3 g1 (.a(1'b0), .b(w142), .c(w353), .x(w516) );
	dmg_not g2 (.a(w370) );

	PPU1 ppu1 (
		.a({w121, w120, w119, w118, w117, w116, w115, w114, w113, w112, w111, w102, w101}),
		.d({w103, w104, w105, w106, w107, w108, w109, w110}),
		.n_ma({w144, w146, w145, w148, w147, w151, w149, w150, w154, w152, w153, w155, w156}),
		.n_lcd_ld1(w157),
		.n_lcd_ld0(w158),
		.n_lcd_cpg(w159),
		.n_lcd_cp(w160),
		.n_lcd_st(w161),
		.n_lcd_cpl(w162),
		.n_lcd_fr(w163),
		.n_lcd_s(w164),
		.CONST0(w259),
		.n_dma_phi(w337),
		.ppu_rd(w355),
		.ppu_wr(w356),
		.ppu_clk(w365),
		.vram_to_oam(w366),
		.ffxx(w395),
		.n_ppu_hard_reset(w396),
		.ff46(w397),
		.nma({w403, w407, w408, w398, w485, w484, w404, w405, w402, w410, w411, w486, w400}),
		.fexx(w399),
		.ff43(w401),
		.ff42(w406),
		.sprite_x_flip(w409),
		.sprite_x_match(w412),
		.bp_sel(w413),
		.ppu_mode3(w450),
		.md({w454, w456, w452, w458, w457, w451, w453, w455}),
		.v({w460, w494, w487, w495, w493, w498, w500, w496}),
		.FF43_D1(w461),
		.FF43_D0(w462),
		.n_ppu_clk(w463),
		.FF43_D2(w464),
		.h({w488, w477, w492, w497, w465, w499, w468, w467}),
		.ppu_mode2(w466),
		.vbl(w469),
		.stop_oam_eval(w470),
		.obj_color(w471),
		.vclk2(w472),
		.h_restart(w473),
		.obj_prio_ck(w474),
		.obj_prio(w475),
		.n_ppu_reset(w476),
		.n_dma_phi2_latched(w483),
		.FF40_D3(w489),
		.FF40_D2(w490),
		.in_window(w491),
		.FF40_D1(w501),
		.sp_bp_cys(w505),
		.tm_bp_cys(w506),
		.n_sp_bp_mrd(w507),
		.n_tm_bp_cys(w508),
		.arb_fexx_ffxx(w509),
		.ppu_int_stat(w512),
		.ppu_int_vbl(w513),
		.oam_mode3_bl_pch(w517),
		.bp_cy(w518),
		.tm_cy(w519),
		.oam_mode3_nrd(w520),
		.ppu1_ma0(w521),
		.oam_rd_ck(w522),
		.oam_xattr_latch_cck(w523),
		.oam_addr_ck(w524)
	);

	PPU2 ppu2 (
		.cclk(w80),
		.clk6(w89),
		.n_reset2(w93),
		.a({w116, w115, w114, w113, w112, w111, w102, w101}),
		.d({w103, w104, w105, w106, w107, w108, w109, w110}),
		.n_oamb({w172, w171, w170, w169, w168, w167, w166, w165}),
		.oam_bl_pch(w173),
		.oa({w180, w179, w178, w177, w176, w175, w174}),
		.n_oam_rd(w181),
		.n_oamb_wr(w182),
		.n_oama_wr(w183),
		.n_oama({w191, w190, w189, w188, w187, w186, w185, w184}),
		.CONST0(w259),
		.n_dma_phi(w337),
		.dma_a({w349, w345, w342, w350, w348, w347, w341, w344, w339, w346, w340, w343, w338}),
		.dma_run(w351),
		.soc_wr(w352),
		.soc_rd(w353),
		.ppu_rd(w355),
		.ppu_wr(w356),
		.ppu_clk(w365),
		.vram_to_oam(w366),
		.n_ppu_hard_reset(w396),
		.nma({w403, w407, w408, w398, w485, w484, w404, w405, w402, w410, w411, w486, w400}),
		.fexx(w399),
		.ff43(w401),
		.ff42(w406),
		.sprite_x_flip(w409),
		.sprite_x_match(w412),
		.bp_sel(w413),
		.ppu_mode3(w450),
		.md({w454, w456, w452, w458, w457, w451, w453, w455}),
		.oam_din({w504, w481, w503, w482, w479, w515, w459, w478}),
		.v({w460, w494, w487, w495, w493, w498, w500, w496}),
		.FF43_D1(w461),
		.FF43_D0(w462),
		.n_ppu_clk(w463),
		.FF43_D2(w464),
		.h({w488, w477, w492, w497, w465, w499, w468, w467}),
		.ppu_mode2(w466),
		.vbl(w469),
		.stop_oam_eval(w470),
		.obj_color(w471),
		.vclk2(w472),
		.h_restart(w473),
		.obj_prio_ck(w474),
		.obj_prio(w475),
		.n_ppu_reset(w476),
		.oam_to_vram(w480),
		.n_dma_phi2_latched(w483),
		.FF40_D3(w489),
		.FF40_D2(w490),
		.in_window(w491),
		.FF40_D1(w501),
		.dma_addr_ext(w502),
		.sp_bp_cys(w505),
		.cpu_vram_oam_rd(w510),
		.oam_dma_wr(w511),
		.clk6_delay(w514),
		.oam_din_2(w515),
		.oam_mode3_bl_pch(w517),
		.bp_cy(w518),
		.tm_cy(w519),
		.oam_mode3_nrd(w520),
		.ma0(w521),
		.oam_rd_ck(w522),
		.oam_xattr_latch_cck(w523),
		.oam_addr_ck(w524)
	);

	OAM oam (
		.n_oamb({w172, w171, w170, w169, w168, w167, w166, w165}),
		.oam_bl_pch(w173),
		.oa({w180, w179, w178, w177, w176, w175, w174}),
		.n_oam_rd(w181),
		.n_oamb_wr(w182),
		.n_oama_wr(w183),
		.n_oama({w191, w190, w189, w188, w187, w186, w185, w184})
	);

	HRAM hram (
		.clk7(w90),
		.a({w116, w115, w114, w113, w112, w111, w102, w101}),
		.d({w103, w104, w105, w106, w107, w108, w109, w110}),
		.soc_wr(w352),
		.soc_rd(w353),
		.ffxx(w395)
	);

	DAC dac (
		.vin_analog(w275),
		.so2_analog(w276),
		.so1_analog(w277),
		.n_ch1_amp_en(w414),
		.n_ch2_amp_en(w415),
		.n_ch3_amp_en(w416),
		.n_ch4_amp_en(w417),
		.ch1_out({w421, w420, w419, w418}),
		.ch2_out({w425, w424, w423, w422}),
		.ch3_out({w429, w428, w427, w426}),
		.ch4_out({w433, w432, w431, w430}),
		.r_vin_en(w434),
		.rmixer({w438, w437, w436, w435}),
		.l_vin_en(w439),
		.lmixer({w443, w442, w441, w440}),
		.n_rvolume({w444, w445, w446}),
		.n_lvolume({w447, w448, w449})
	);

	BootROM bootrom (
		.a({w124, w123, w122, w121, w120, w119, w118, w117, w116, w115, w114, w113, w112, w111, w102, w101}),
		.d({w103, w104, w105, w106, w107, w108, w109, w110}),
		.from_g1_YULA(w516)
	);

	Ser ser (
		.n_reset2(w93),
		.d({w103, w104, w105, w106, w107, w108, w109, w110}),
		.n_sin(w252),
		.sck_dir(w255),
		.n_sck(w256),
		.int_serial(w357),
		.sc_read(w358),
		.sb_read(w359),
		.sc_write(w360),
		.n_sb_write(w361),
		.lfo_16384Hz(w362),
		.ser_out(w363),
		.serial_tick(w364)
	);

	ClkGen clkgen (
		.n_clk_in(w78),
		.reset(w79),
		.cclk(w80),
		.clk1(w81),
		.clk2(w82),
		.clk3(w83),
		.clk4(w84),
		.osc_stable(w85),
		.clk_ena(w86),
		.osc_ena(w87),
		.clk5(w88),
		.clk6(w89),
		.clk7(w90),
		.clk8(w91),
		.clk9(w92),
		.n_reset2(w93),
		.sync_reset(w94),
		.cpu_mreq(w95),
		.ext_cs_en(w96),
		.cpu_wr_sync(w97),
		.cpu_wr(w140),
		.test_1(w369),
		.n_test_reset(w374)
	);

	MMIO mmio (
		.reset(w79),
		.clk2(w82),
		.clk4(w84),
		.osc_stable(w85),
		.clk_ena(w86),
		.osc_ena(w87),
		.clk6(w89),
		.clk9(w92),
		.n_reset2(w93),
		.cpu_wr_sync(w97),
		.cpu_m1(w99),
		.n_cpu_m1(w100),
		.a({w123, w122, w121, w120, w119, w118, w117, w116, w115, w114, w113, w112, w111, w102, w101}),
		.d({w103, w104, w105, w106, w107, w108, w109, w110}),
		.cpu_irq_trig({w128, w130, w132, w134, w136}),
		.cpu_irq_ack({w129, w131, w133, w135, w137}),
		.cpu_rd(w139),
		.cpu_wr(w140),
		.n_DRV_HIGH_a({1'bz, w195, w198, w201, w204, w207, w210, w213, 8'bz}),
		.n_INPUT_a({1'bz, w196, w199, w202, w205, w208, w211, w214, 8'bz}),
		.DRV_LOW_a({1'bz, w197, w200, w203, w206, w209, w212, w215, 8'bz}),
		.n_DRV_HIGH_nrd(w241),
		.n_INPUT_nrd(w242),
		.DRV_LOW_nrd(w243),
		.n_DRV_HIGH_nwr(w244),
		.n_INPUT_nwr(w245),
		.DRV_LOW_nwr(w246),
		.n_t1_frompad(w247),
		.n_t2_frompad(w248),
		.CONST0(w259),
		.n_ena_pu_db(w315),
		.n_dma_phi(w337),
		.dma_a({w349, w345, w342, w350, w348, w347, w341, w344, w339, w346, w340, w343, w338}),
		.dma_run(w351),
		.soc_wr(w352),
		.soc_rd(w353),
		.lfo_512Hz(w354),
		.ppu_rd(w355),
		.ppu_wr(w356),
		.int_serial(w357),
		.sc_read(w358),
		.sb_read(w359),
		.sc_write(w360),
		.n_sb_write(w361),
		.lfo_16384Hz(w362),
		.ppu_clk(w365),
		.vram_to_oam(w366),
		.dma_a_15(w367),
		.non_vram_mreq(w368),
		.test_1(w369),
		.test_2(w370),
		.n_extdb_to_intdb(w371),
		.n_dblatch_to_intdb(w372),
		.n_intdb_to_extdb(w373),
		.n_test_reset(w374),
		.n_ext_addr_en(w375),
		.addr_latch(w392),
		.int_jp(w393),
		.FF60_D1(w394),
		.ffxx(w395),
		.n_ppu_hard_reset(w396),
		.ff46(w397),
		.dma_addr_ext(w502),
		.cpu_vram_oam_rd(w510),
		.oam_dma_wr(w511),
		.ppu_int_stat(w512),
		.ppu_int_vbl(w513),
		.clk6_delay(w514)
	);

	SM83Core core (
		.RESET(w79),
		.CLK1(w81),
		.CLK2(w82),
		.CLK3(w83),
		.CLK4(w84),
		.OSC_STABLE(w85),
		.CLK_ENA(w86),
		.OSC_ENA(w87),
		.CLK5(w88),
		.CLK6(w89),
		.CLK7(w90),
		.CLK8(w91),
		.CLK9(w92),
		.SYNC_RESET(w94),
		.CPU_MREQ(w95),
		.NMI(w98),
		.M1(w99),
		.A({w124, w123, w122, w121, w120, w119, w118, w117, w116, w115, w114, w113, w112, w111, w102, w101}),
		.D({w103, w104, w105, w106, w107, w108, w109, w110}),
		.CPU_IRQ_TRIG({1'b0, 1'b0, 1'b0, w128, w130, w132, w134, w136}),
		.CPU_IRQ_ACK({1'bz, 1'bz, 1'bz, w129, w131, w133, w135, w137}),
		.WAKE(w138),
		.RD(w139),
		.WR(w140),
		.MMIO_REQ(w141),
		.IPL_REQ(w142),
		.BUS_DISABLE(w369),
		.IPL_DISABLE(w370)
	);

	Arbiter arb (
		.clk2(w82),
		.n_reset2(w93),
		.cpu_mreq(w95),
		.ext_cs_en(w96),
		.cpu_wr_sync(w97),
		.a({w124, w123, w122, w121, w120, w119, w118, w117, w116, w115, w114, w113, w112, w111, w102, w101}),
		.d({w103, w104, w105, w106, w107, w108, w109, w110}),
		.cpu_wr(w140),
		.mmio_sel(w141),
		.boot_sel(w142),
		.n_DRV_HIGH_a({w192, 14'bz}),
		.n_INPUT_a({w193, 14'bz}),
		.DRV_LOW_a({w194, 14'bz}),
		.n_cs_topad(w240),
		.CONST0(w259),
		.n_DRV_HIGH_nmwr(w278),
		.n_mwr(w279),
		.DRV_LOW_nmwr(w280),
		.n_DRV_HIGH_nmrd(w281),
		.n_mrd(w282),
		.DRV_LOW_nmrd(w283),
		.n_DRV_HIGH_nmcs(w284),
		.n_mcs(w285),
		.DRV_LOW_nmcs(w286),
		.n_DRV_HIGH_md({w287, w291, w294, w297, w300, w303, w306, w309}),
		.n_md_frompad({w288, w292, w295, w298, w301, w304, w307, w311}),
		.DRV_LOW_md({w289, w293, w296, w299, w302, w305, w308, w310}),
		.n_md_ena_pu(w290),
		.n_DRV_HIGH_d({w312, w316, w319, w322, w325, w328, w331, w334}),
		.n_db_frompad({w313, w317, w320, w323, w326, w329, w332, w335}),
		.DRV_LOW_d({w314, w318, w321, w324, w327, w330, w333, w336}),
		.n_ena_pu_db(w315),
		.soc_wr(w352),
		.soc_rd(w353),
		.vram_to_oam(w366),
		.dma_a_15(w367),
		.non_vram_mreq(w368),
		.test_1(w369),
		.n_extdb_to_intdb(w371),
		.n_dblatch_to_intdb(w372),
		.n_intdb_to_extdb(w373),
		.ffxx(w395),
		.n_ppu_hard_reset(w396),
		.ppu_mode3(w450),
		.md({w454, w456, w452, w458, w457, w451, w453, w455}),
		.oam_din({w504, w481, w503, w482, w479, w515, w459, w478}),
		.oam_to_vram(w480),
		.dma_addr_ext(w502),
		.sp_bp_cys(w505),
		.tm_bp_cys(w506),
		.n_sp_bp_mrd(w507),
		.n_tm_bp_cys(w508),
		.arb_fexx_ffxx(w509),
		.cpu_vram_oam_rd(w510),
		.oam_din_2(w515)
	);

	APU apu (
		.cclk(w80),
		.clk2(w82),
		.clk4(w84),
		.clk6(w89),
		.clk7(w90),
		.clk9(w92),
		.n_reset2(w93),
		.a({w116, w115, w114, w113, w112, w111, w102, w101}),
		.d({w103, w104, w105, w106, w107, w108, w109, w110}),
		.cpu_wakeup(w138),
		.n_DRV_HIGH_a({8'bz, w216, w219, w222, w225, w228, w231, w234, w237}),
		.n_INPUT_a({8'bz, w217, w220, w223, w226, w229, w232, w235, w238}),
		.DRV_LOW_a({8'bz, w218, w221, w224, w227, w230, w233, w236, w239}),
		.n_sout_topad(w249),
		.n_DRV_HIGH_sin(w250),
		.n_ENA_PU_sin(w251),
		.DRV_LOW_sin(w253),
		.n_DRV_HIGH_sck(w254),
		.sck_dir(w255),
		.DRV_LOW_sck(w257),
		.n_DRV_HIGH_p10(w258),
		.CONST0(w259),
		.n_p10(w260),
		.DRV_LOW_p10(w261),
		.n_DRV_HIGH_p11(w262),
		.n_p11(w263),
		.DRV_LOW_p11(w264),
		.n_DRV_HIGH_p12(w265),
		.n_p12(w266),
		.DRV_LOW_p12(w267),
		.n_DRV_HIGH_p13(w268),
		.n_p13(w269),
		.DRV_LOW_p13(w270),
		.n_DRV_HIGH_p14(w271),
		.DRV_LOW_p14(w272),
		.n_DRV_HIGH_p15(w273),
		.DRV_LOW_p15(w274),
		.dma_a({w347, w341, w344, w339, w346, w340, w343, w338}),
		.soc_wr(w352),
		.soc_rd(w353),
		.lfo_512Hz(w354),
		.ser_out(w363),
		.serial_tick(w364),
		.test_1(w369),
		.test_2(w370),
		.n_ext_addr_en(w375),
		.ch3_active(w376),
		.wave_a({w378, w377, w380, w379}),
		.wave_rd({w388, w387, w386, w385, w384, w383, w382, w381}),
		.n_wave_wr(w389),
		.wave_bl_pch(w390),
		.n_wave_rd(w391),
		.addr_latch(w392),
		.int_jp(w393),
		.FF60_D1(w394),
		.ffxx(w395),
		.n_ch1_amp_en(w414),
		.n_ch2_amp_en(w415),
		.n_ch3_amp_en(w416),
		.n_ch4_amp_en(w417),
		.ch1_out({w421, w420, w419, w418}),
		.ch2_out({w425, w424, w423, w422}),
		.ch3_out({w429, w428, w427, w426}),
		.ch4_out({w433, w432, w431, w430}),
		.r_vin_en(w434),
		.rmixer({w438, w437, w436, w435}),
		.l_vin_en(w439),
		.lmixer({w443, w442, w441, w440}),
		.n_rvolume({w444, w445, w446}),
		.n_lvolume({w447, w448, w449}),
		.dma_addr_ext(w502)
	);

	WaveRAM waveram (
		.d({w103, w104, w105, w106, w107, w108, w109, w110}),
		.active(w376),
		.a({w378, w377, w380, w379}),
		.dout({w388, w387, w386, w385, w384, w383, w382, w381}),
		.n_wr(w389),
		.bl_pch(w390),
		.n_rd(w391)
	);

endmodule // dmgcpu

// ERROR: floating wire w125
// ERROR: floating wire w126
// ERROR: floating wire w127
// ERROR: floating wire w143
// WARNING: Cell OBUF_A:pad_m1 port PAD_OUT not connected.
// WARNING: Cell IBUF_B:pad_nnmi port PAD_IN not connected.
// WARNING: Cell SM83Core:core port CPU_IRQ_ACK[7] not connected.
// WARNING: Cell SM83Core:core port CPU_IRQ_ACK[6] not connected.
// WARNING: Cell SM83Core:core port CPU_IRQ_ACK[5] not connected.
// WARNING: Cell not:g2 port x not connected.
