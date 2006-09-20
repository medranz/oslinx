program_name='Main'

define_device

dvTP = 10001:1:1

define_variable

integer i

integer h2rRreturn  //because functions can't return arrays; correct?
integer h2rGreturn
integer h2rBreturn
integer r2hHreturn
integer r2hSreturn
integer r2hVreturn

define_event

button_event[dvTP, 1] {
    push: {
	i=h2r(245, 0, 34)
    }
}

button_event[dvTP, 2] {
    push: {
	i=r2h(255, 87, 87)
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

