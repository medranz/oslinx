program_name='Main'

define_device

dvTP = 10001:1:1

define_variable

char	cdebug[255]

integer i
integer levels[3]
integer color[8][3]	//color value storage in RGB

integer h2rRreturn  //because functions can't return arrays; correct?
integer h2rGreturn
integer h2rBreturn
integer r2hHreturn
integer r2hSreturn
integer r2hVreturn

define_event

button_event[dvTP, 1] {
    push: {
	i=h2r(0, 100, 85)
    }
}

button_event[dvTP, 2] {
    push: {
	i=r2h(0, 100, 85)
    }
}

level_event[dvTP, 1] level_event[dvTP, 2] level_event[dvTP, 3] {
    levels[level.input.level] = level.value
    //filter dragging
    cancel_wait 'level_change'  
    wait 5 'level_change' {
	dom(levels[1], levels[2], levels[3])
    }
}

(****************************************)
(*  Hue, Saturation, & Value to RGB     *)
(*  Usage: h2r(hue, saturation, value)  *)
(*  Returns integer 1 on success        *)
(*  RGBs are "returned" in h2rRreturn,  *)
(*    h2rGreturn, h2rBreturn            *)
(*  TODO: Can functions return arrays?  *)
(****************************************)
define_function integer h2r(float h2rhsH, float h2rhsS, float h2rhsV) {
    stack_var float h2rR
    stack_var float h2rG
    stack_var float h2rB
    stack_var float f
    stack_var float p
    stack_var float q
    stack_var float t
    if(h2rhsS==0) {
	h2rRreturn=type_cast((h2rhsV*2.55) + 0.5)
	h2rGreturn=type_cast((h2rhsV*2.55) + 0.5)
	h2rBreturn=type_cast((h2rhsV*2.55) + 0.5)
	if((h2rRreturn >= 0 && h2rRreturn <= 255) && (h2rGreturn >= 0 && h2rGreturn <= 255) && (h2rBreturn >= 0 && h2rBreturn <= 255))
	    return 1
	else
	    return 0
    }
    h2rhsS=h2rhsS/100
    h2rhsV=h2rhsV/100
    h2rhsH=h2rhsH/60
    i=type_cast(h2rhsH)  //round to but not higher
    f=h2rhsH-i
    p=h2rhsV*(1-h2rhsS)
    q=h2rhsV*(1-h2rhsS*f)
    t=h2rhsV*(1-h2rhsS*(1-f))
    switch(i) {
	case 0: {
	    h2rR=h2rhsV
	    h2rG=t
	    h2rB=p
	    break
	}
	case 1: {
	    h2rR=q
	    h2rG=h2rhsV
	    h2rB=p
	    break
	}
	case 2: {
	    h2rR=p;
	    h2rG=h2rhsV;
	    h2rB=t;
	    break
	}
	case 3: {
	    h2rR=p
	    h2rG=q
	    h2rB=h2rhsV
	    break
	}
	case 4: {
	    h2rR=t
	    h2rG=p
	    h2rB=h2rhsV
	    break
	}
	default: {
	    h2rR=h2rhsV
	    h2rG=p
	    h2rB=q
	}
    }
    h2rRreturn=type_cast((h2rR*255) + 0.5)  //round
    h2rGreturn=type_cast((h2rG*255) + 0.5)  //round
    h2rBreturn=type_cast((h2rB*255) + 0.5)  //round
    if((h2rRreturn >= 0 && h2rRreturn <= 255) && (h2rGreturn >= 0 && h2rGreturn <= 255) && (h2rBreturn >= 0 && h2rBreturn <= 255))
	return 1
    else
	return 0
}

(****************************************)
(*  RGB to Hue, Saturation, & Value     *)
(*  Usage: r2h(red, green, blue)        *)
(*  Returns integer 1 on success        *)
(*  HSVs are "returned" in r2hHreturn,  *)
(*    r2hSreturn, r2hVreturn            *)
(*  TODO: Can functions return arrays?  *)
(****************************************)
define_function integer r2h(integer rgR, integer rgG, integer rgB) {
    stack_var float r2hhsS
    stack_var float r2hhsV
    stack_var float r2hhsH
    stack_var integer m
    stack_var integer v
    stack_var integer value
    stack_var integer delta
    m=rgR
    if(rgG<m) m=rgG
    if(rgB<m) m=rgB
    v=rgR
    if(rgG>v) v=rgG
    if(rgB>v) v=rgB
    value=100*v/255
    delta=v-m
    if(v==0.0) r2hhsS=0 else r2hhsS=100*delta/v
    if(r2hhsS==0) {
	r2hhsH=0
    } else {
	if(rgR==v) {
	    r2hhsH=(60*(rgG-rgB))/delta
	} else if(rgG==v) {
	    r2hhsH=120+((60*(rgB-rgR))/delta)
	} else if(rgB=v) {
	    r2hhsH=240+((60*(rgR-rgG))/delta)
	}
	if(r2hhsH<0.0) r2hhsH=r2hhsH+360
    }
    r2hHreturn = type_cast(r2hhsH + 0.5)
    r2hSreturn = type_cast(r2hhsS)
    r2hVreturn = type_cast(value)
    if((r2hHreturn >= 0 && r2hHreturn <= 360) && (r2hSreturn >= 0 && r2hSreturn <= 100) && (r2hVreturn >= 0 && r2hVreturn <= 100))
	return 1
    else
	return 0
}

define_function integer rc(x,m) {
    if(x>m) {
	return m
    }
    if(x<0) {
	return 0
    } else {
	return x
    }
}

define_function ud(integer x, integer cR, integer cG, integer cB) {
    //paints buttons  see BCT command
//    document.getElementById("sw"+x).style.backgroundColor="rgb("+c.r+","+c.g+","+c.b+")";
//    document.getElementById("hc"+x).innerHTML=rg2html(c) + "<br />R: "+c.r+"<br />G: "+c.g+"<br />B: "+c.b;
//    document.getElementById("col"+x).value="#"+rg2html(c)
}

define_function dom(integer domR, integer domG, integer domB) {
//    z=new Object();
//    y=new Object();
//    yx=new Object();
//    p=new Object();
//    pr=new Object();
    stack_var float pH
    stack_var float pS
    stack_var float pV
    stack_var float yH
    stack_var float yS
    stack_var float yV
    stack_var float prH
    stack_var float prS
    stack_var float prV
    stack_var float yxH
    stack_var float yxS
    stack_var float yxV
    color[1][1] = domR
    color[1][2] = domG
    color[1][3] = domB
    send_command dvTP, "'^BCF-4&6,0,#', format('%02X', color[1][1]), format('%02X', color[1][2]), format('%02X', color[1][3])" 
    send_command dvTP, "'^BMF-5&7,0,%T#', format('%02X', color[1][1]), format('%02X', color[1][2]), format('%02X', color[1][3])" 
    r2h(domR, domG, domB)
    yS = r2hSreturn
    pS = yS
    yH = r2hHreturn
    pH = yH
    if(r2hVreturn > 70) {
	yV = r2hVreturn - 30
	pV = yV + 15
    } else {
	yV = r2hVreturn + 30
	pV = yV - 15
    }
    h2r(type_cast(pH), type_cast(pS), type_cast(pV))
    color[2][1] = h2rRreturn
    color[2][2] = h2rGreturn
    color[2][3] = h2rBreturn
    send_command dvTP, "'^BCF-8,0,#', format('%02X', color[2][1]), format('%02X', color[2][2]), format('%02X', color[2][3])" 
    send_command dvTP, "'^BMF-9,0,%T#', format('%02X', color[2][1]), format('%02X', color[2][2]), format('%02X', color[2][3])" 
    h2r(type_cast(yH), type_cast(yS), type_cast(yV))
    color[3][1] = h2rRreturn
    color[3][2] = h2rGreturn
    color[3][3] = h2rBreturn
    send_command dvTP, "'^BCF-10,0,#', format('%02X', color[3][1]), format('%02X', color[3][2]), format('%02X', color[3][3])" 
    send_command dvTP, "'^BMF-11,0,%T#', format('%02X', color[3][1]), format('%02X', color[3][2]), format('%02X', color[3][3])" 

    if(r2hHreturn >= 0 && r2hHreturn < 30) {
	prH = r2hHreturn + 20
	yxH = r2hHreturn + 20
	yH = r2hHreturn + 20
	prS = r2hSreturn
	yxS = r2hSreturn
	yS = r2hSreturn
	yv = r2hVreturn
	if(r2hHreturn > 70 ) {
	    yxV = r2hVreturn - 30
	    prV = yxV + 15
	} else {
	    yxV = r2hVreturn + 30
	    prV = yxV - 15
	}
    }
//    if((hs.h>=30)&&(hs.h<60)) {
    if(r2hHreturn >= 30 && r2hHreturn < 60) {
//	pr.h=yx.h=y.h=hs.h+150;
	prH = r2hHreturn + 150
	yxH = r2hHreturn + 150
	yH = r2hHreturn + 150
//	y.s=rc(hs.s-30,100);
//	y.v=rc(hs.v-20,100);
	yS = rc(r2hHreturn - 30, 100)
	yV = rc(r2hVreturn - 20, 100)
//	pr.s=yx.s=rc(hs.s-70,100);
	yxS = rc(r2hSreturn - 70, 100)
	prS = rc(r2hSreturn - 70, 100)
//	yx.v=rc(hs.v+20,100);
	yxV = rc(r2hVreturn + 20, 100)
//	pr.v=hs.v
	prV = r2hVreturn
    }
//    if((hs.h>=60)&&(hs.h<180)) {
//	pr.h=yx.h=y.h=hs.h-40;
//	pr.s=y.s=yx.s=hs.s;
//	y.v=hs.v;
//	if(hs.v>70) {
//	    yx.v=hs.v-30
//	    pr.v = yx.v +15
//	} else {
//	    yx.v=hs.v+30
//	    pr.v = yx.v -15
//	}
//    }
//    if((hs.h>=180)&&(hs.h<220)) {
//	pr.h=yx.h=hs.h-170;
//	y.h=hs.h-160;
//	pr.s=yx.s=y.s=hs.s;
//	y.v=hs.v;
//	if(hs.v>70) {
//	    yx.v=hs.v-30
//	    pr.v = yx.v +15
//	} else {
//	    yx.v=hs.v+30
//	    pr.v = yx.v -15
//	}
//    }
//    if((hs.h>=220)&&(hs.h<300)) {
//	pr.h=yx.h=y.h=hs.h;
//	pr.s=yx.s=y.s=rc(hs.s-60,100);
//	y.v=hs.v;
//	if(hs.v>70) {
//	    yx.v=hs.v-30
//	    pr.v = yx.v +15
//	} else {
//	    yx.v=hs.v+30
//	    pr.v = yx.v -15
//	}
//    }
//    if(hs.h>=300) {
//	if(hs.s>50) {
//	    pr.s=y.s=yx.s=hs.s-40
//	} else {
//	    pr.s=y.s=yx.s=hs.s+40
//	}
//	pr.h=yx.h=y.h=(hs.h+20)%360;
//	y.v=hs.v;
//	if(hs.v>70) {
//	    yx.v=hs.v-30
//	    pr.v = yx.v +15
//	} else {
//	    yx.v=hs.v+30
//	    pr.v = yx.v -15
//	}
//    }



//    z=h2r(y);
//    ud("3",z);
    h2r(type_cast(yH), type_cast(yS), type_cast(yV))
    color[4][1] = h2rRreturn
    color[4][2] = h2rGreturn
    color[4][3] = h2rBreturn
    send_command dvTP, "'^BCF-12,0,#', format('%02X', color[4][1]), format('%02X', color[4][2]), format('%02X', color[4][3])" 
    send_command dvTP, "'^BMF-13,0,%T#', format('%02X', color[4][1]), format('%02X', color[4][2]), format('%02X', color[4][3])" 


//    z=h2r(yx);
//    ud("5",z);
    h2r(type_cast(yxH), type_cast(yxS), type_cast(yxV))
    color[6][1] = h2rRreturn
    color[6][2] = h2rGreturn
    color[6][3] = h2rBreturn
    send_command dvTP, "'^BCF-16,0,#', format('%02X', color[6][1]), format('%02X', color[6][2]), format('%02X', color[6][3])" 
    send_command dvTP, "'^BMF-17,0,%T#', format('%02X', color[6][1]), format('%02X', color[6][2]), format('%02X', color[6][3])" 

    yH=0
    yS=0
    yV=100-r2hVreturn
//    z=h2r(y);
//    ud("6",z);
    h2r(type_cast(yH), type_cast(yS), type_cast(yV))
    color[7][1] = h2rRreturn
    color[7][2] = h2rGreturn
    color[7][3] = h2rBreturn
    send_command dvTP, "'^BCF-18,0,#', format('%02X', color[7][1]), format('%02X', color[7][2]), format('%02X', color[7][3])" 
    send_command dvTP, "'^BMF-19,0,%T#', format('%02X', color[7][1]), format('%02X', color[7][2]), format('%02X', color[7][3])" 

    yH=0
    yS=0
    yV=r2hVreturn
//    z=h2r(y);
//    ud("7",z);
    h2r(type_cast(yH), type_cast(yS), type_cast(yV))
    color[8][1] = h2rRreturn
    color[8][2] = h2rGreturn
    color[8][3] = h2rBreturn
    send_command dvTP, "'^BCF-20,0,#', format('%02X', color[8][1]), format('%02X', color[8][2]), format('%02X', color[8][3])" 
    send_command dvTP, "'^BMF-21,0,%T#', format('%02X', color[8][1]), format('%02X', color[8][2]), format('%02X', color[8][3])" 


//    z=h2r(pr);
//    ud("4",z);
    h2r(type_cast(yH), type_cast(yS), type_cast(yV))
    color[5][1] = h2rRreturn
    color[5][2] = h2rGreturn
    color[5][3] = h2rBreturn
    send_command dvTP, "'^BCF-14,0,#', format('%02X', color[5][1]), format('%02X', color[5][2]), format('%02X', color[5][3])" 
    send_command dvTP, "'^BMF-15,0,%T#', format('%02X', color[5][1]), format('%02X', color[5][2]), format('%02X', color[5][3])" 


//    if(hs.v >= 50) { pr.v = 0 } else { pr.v = 100 } 
//    pr.h=pr.s=0;
//    z=h2r(pr);
//    ud("8",z)

}


