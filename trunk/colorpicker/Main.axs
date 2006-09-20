program_name='Main'

define_device

dvTP = 10001:1:1

define_variable

char	cdebug[255]

integer i
integer levels[3]
integer color[8][3]	//color value storage in RGB

integer h2rReturn[3]  //because functions can't return arrays; correct?
float	r2hReturn[3]

define_event

level_event[dvTP, 1] level_event[dvTP, 2] level_event[dvTP, 3] {
    levels[level.input.level] = level.value
    //filter dragging
    cancel_wait 'level_change'  
    wait 5 'level_change' {
//	dom(levels[1], levels[2], levels[3])
	f_dom(levels)
    }
}

(****************************************)
(*  Hue, Saturation, & Value to RGB     *)
(*  Usage: f_h2r(hue, saturation, value)  *)
(*  Returns integer 1 on success        *)
(*  RGBs are "returned" in h2rReturn[1],  *)
(*    h2rReturn[2], h2rReturn[3]            *)
(*  TODO: Can functions return arrays?  *)
(****************************************)
define_function integer f_h2r(float h2rhsH, float h2rhsS, float h2rhsV) {
    stack_var float h2rR
    stack_var float h2rG
    stack_var float h2rB
    stack_var float f
    stack_var float p
    stack_var float q
    stack_var float t
    if(h2rhsS==0) {
	h2rReturn[1]=type_cast((h2rhsV*2.55) + 0.5)
	h2rReturn[2]=type_cast((h2rhsV*2.55) + 0.5)
	h2rReturn[3]=type_cast((h2rhsV*2.55) + 0.5)
	if((h2rReturn[1] >= 0 && h2rReturn[1] <= 255) && (h2rReturn[2] >= 0 && h2rReturn[2] <= 255) && (h2rReturn[3] >= 0 && h2rReturn[3] <= 255))
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
    h2rReturn[1]=type_cast((h2rR*255) + 0.5)  //round
    h2rReturn[2]=type_cast((h2rG*255) + 0.5)  //round
    h2rReturn[3]=type_cast((h2rB*255) + 0.5)  //round
    if((h2rReturn[1] >= 0 && h2rReturn[1] <= 255) && (h2rReturn[2] >= 0 && h2rReturn[2] <= 255) && (h2rReturn[3] >= 0 && h2rReturn[3] <= 255))
	return 1
    else
	return 0
}

(****************************************)
(*  RGB to Hue, Saturation, & Value     *)
(*  Usage: f_r2h(red, green, blue)        *)
(*  Returns integer 1 on success        *)
(*  HSVs are "returned" in r2hReturn[1],  *)
(*    r2hReturn[2], r2hReturn[3]            *)
(*  TODO: Can functions return arrays?  *)
(****************************************)
define_function integer f_r2h(float rgR, float rgG, float rgB) {
    stack_var float r2hhsS
    stack_var float r2hhsV
    stack_var float r2hhsH
    stack_var float m
    stack_var float v
    stack_var float value
    stack_var float delta
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
    r2hReturn[1] = type_cast(r2hhsH + 0.5)
    r2hReturn[2] = type_cast(r2hhsS)
    r2hReturn[3] = type_cast(value)
    if((r2hReturn[1] >= 0 && r2hReturn[1] <= 360) && (r2hReturn[2] >= 0 && r2hReturn[2] <= 100) && (r2hReturn[3] >= 0 && r2hReturn[3] <= 100))
	return 1
    else
	return 0
}

define_function float rc(float x, float m) {
    if(x>m) {
	return m
    }
    if(x<0) {
	return 0
    } else {
	return x
    }
}

define_function f_dom(integer dom[3]) {
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
    color[1] = dom
    send_command dvTP, "'^BCF-4&6,0,#', format('%02X', color[1][1]), format('%02X', color[1][2]), format('%02X', color[1][3])" 
    send_command dvTP, "'^BMF-5&7,0,%T#', format('%02X', color[1][1]), format('%02X', color[1][2]), format('%02X', color[1][3])" 
    f_r2h(type_cast(dom[1]), type_cast(dom[2]), type_cast(dom[3]))
    yS = r2hReturn[2]
    pS = yS
    yH = r2hReturn[1]
    pH = yH
    if(r2hReturn[3] > 70) {
	yV = r2hReturn[3] - 30
	pV = yV + 15
    } else {
	yV = r2hReturn[3] + 30
	pV = yV - 15
    }

    f_h2r(pH, pS, pV)
    color[2] = h2rReturn
    send_command dvTP, "'^BCF-8,0,#', format('%02X', color[2][1]), format('%02X', color[2][2]), format('%02X', color[2][3])" 
    send_command dvTP, "'^BMF-9,0,%T#', format('%02X', color[2][1]), format('%02X', color[2][2]), format('%02X', color[2][3])" 

    f_h2r(yH, yS, yV)
    color[3] = h2rReturn
    send_command dvTP, "'^BCF-10,0,#', format('%02X', color[3][1]), format('%02X', color[3][2]), format('%02X', color[3][3])" 
    send_command dvTP, "'^BMF-11,0,%T#', format('%02X', color[3][1]), format('%02X', color[3][2]), format('%02X', color[3][3])" 

    if(r2hReturn[1] >= 0 && r2hReturn[1] < 30) {
	prH = r2hReturn[1] + 20
	yxH = r2hReturn[1] + 20
	yH = r2hReturn[1] + 20
	prS = r2hReturn[2]
	yxS = r2hReturn[2]
	yS = r2hReturn[2]
	yv = r2hReturn[3]
	if(r2hReturn[3] > 70 ) {
	    yxV = r2hReturn[3] - 30
	    prV = yxV + 15
	} else {
	    yxV = r2hReturn[3] + 30
	    prV = yxV - 15
	}
    }
    if(r2hReturn[1] >= 30 && r2hReturn[1] < 60) {
	prH = r2hReturn[1] + 150
	yxH = r2hReturn[1] + 150
	yH = r2hReturn[1] + 150
	yS = rc(r2hReturn[1] - 30, 100)
	yV = rc(r2hReturn[3] - 20, 100)
	yxS = rc(r2hReturn[2] - 70, 100)
	prS = rc(r2hReturn[2] - 70, 100)
	yxV = rc(r2hReturn[3] + 20, 100)
	prV = r2hReturn[3]
    }
    if(r2hReturn[1] >= 60 && r2hReturn[1] < 180) {
	prH = r2hReturn[1] - 40
	yxH = r2hReturn[1] - 40
	yH = r2hReturn[1] - 40
	prS = r2hReturn[2]
	yS = r2hReturn[2]
	yxS = r2hReturn[2]
	yV = r2hReturn[3]
	if(r2hReturn[3] > 70) {
	    yxV = r2hReturn[3] - 30
	    prV = yxV + 15
	} else {
	    yxV = r2hReturn[3] + 30
	    prV = yxV - 15
	}
    }
    if(r2hReturn[1] >= 180 && r2hReturn[1] < 220) {
	prH = r2hReturn[1] - 170
	yxH = r2hReturn[1] - 170
	yH = r2hReturn[1] - 160
	prS = r2hReturn[2]
	yxS = r2hReturn[2]
	yS = r2hReturn[2]
	yV = r2hReturn[3]
	if(r2hReturn[3] > 70) {
	    yxV = r2hReturn[3] - 30
	    prV = yxV + 15
	} else {
	    yxV = r2hReturn[3] + 30
	    prV = yxV - 15
	}
    }
    if(r2hReturn[1] >= 220 && r2hReturn[1] < 300) {
	prH = r2hReturn[1]
	yxH = r2hReturn[1]
	yH = r2hReturn[1]
	prS = rc(r2hReturn[2] - 60, 100)
	yxS = prS
	yS = yxS
	yV = r2hReturn[3]
	if(r2hReturn[3] > 70) {
	    yxV = r2hReturn[3] - 30
	    prV = yxV + 15
	} else {
	    yxV = r2hReturn[3] + 30
	    prV = yxV - 15
	}
    }
    if(r2hReturn[1] >= 300) {
	if(r2hReturn[2] > 50) {
	    prS = r2hReturn[2] - 40
	} else {
	    prS = r2hReturn[2] + 40
	}
	yS = prS
	yxS = yS
	prH = (r2hReturn[1] + 20) % 360
	yH = prH
	yxH = yH
	yV = r2hReturn[3]
	if(r2hReturn[3] > 70) {
	    yxV = r2hReturn[3] - 30
	    prV = yxV + 15
	} else {
	    yxV = r2hReturn[3] + 30
	    prV = yxV - 15
	}
    }

    f_h2r(yH, yS, yV)
    color[4] = h2rReturn
    send_command dvTP, "'^BCF-12,0,#', format('%02X', color[4][1]), format('%02X', color[4][2]), format('%02X', color[4][3])" 
    send_command dvTP, "'^BMF-13,0,%T#', format('%02X', color[4][1]), format('%02X', color[4][2]), format('%02X', color[4][3])" 

    f_h2r(yxH, yxS, yxV)
    color[6] = h2rReturn
    send_command dvTP, "'^BCF-16,0,#', format('%02X', color[6][1]), format('%02X', color[6][2]), format('%02X', color[6][3])" 
    send_command dvTP, "'^BMF-17,0,%T#', format('%02X', color[6][1]), format('%02X', color[6][2]), format('%02X', color[6][3])" 

    yH=0
    yS=0
    yV=100-r2hReturn[3]
    f_h2r(yH, yS, yV)
    color[7] = h2rReturn
    send_command dvTP, "'^BCF-18,0,#', format('%02X', color[7][1]), format('%02X', color[7][2]), format('%02X', color[7][3])" 
    send_command dvTP, "'^BMF-19,0,%T#', format('%02X', color[7][1]), format('%02X', color[7][2]), format('%02X', color[7][3])" 

    yH=0
    yS=0
    yV=r2hReturn[3]
    f_h2r(yH, yS, yV)
    color[8] = h2rReturn
    send_command dvTP, "'^BCF-20,0,#', format('%02X', color[8][1]), format('%02X', color[8][2]), format('%02X', color[8][3])" 
    send_command dvTP, "'^BMF-21,0,%T#', format('%02X', color[8][1]), format('%02X', color[8][2]), format('%02X', color[8][3])" 

    f_h2r(prH, prS, prV)
    color[5] = h2rReturn
    send_command dvTP, "'^BCF-14,0,#', format('%02X', color[5][1]), format('%02X', color[5][2]), format('%02X', color[5][3])" 
    send_command dvTP, "'^BMF-15,0,%T#', format('%02X', color[5][1]), format('%02X', color[5][2]), format('%02X', color[5][3])" 

//todo: decide on this crap
//    if(hs.v >= 50) { pr.v = 0 } else { pr.v = 100 } 
//    pr.h=pr.s=0;
//    z=f_h2r(pr);
//    ud("8",z)

}


