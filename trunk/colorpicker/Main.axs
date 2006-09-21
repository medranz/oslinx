program_name='Main'

define_device

dvTP = 10001:1:1

define_variable

volatile   integer i
volatile   integer levels[3]
persistent integer color[8][3]	//color value storage in RGB

integer h2rReturn[3]	//because functions can't return arrays; correct?
float	r2hReturn[3]

define_event

data_event[dvTP] {
    online: {
	for(i=1;i<4;i++) send_level dvTP, i, (color[1][i])
    }
}

level_event[dvTP, 1] level_event[dvTP, 2] level_event[dvTP, 3] {
    levels[level.input.level] = level.value
    cancel_wait 'level_change'      //filter dragging
    wait 5 'level_change' {
	f_dom(levels)
    }
}

button_event[dvTP, 11] button_event[dvTP, 12] button_event[dvTP, 13] button_event[dvTP, 14]
button_event[dvTP, 15] button_event[dvTP, 16] button_event[dvTP, 17] {
    push: {
	for(i=1;i<4;i++) send_level dvTP, i, (color[button.input.channel-9][i])
    }
}

button_event[dvTP, 4] button_event[dvTP, 5] {  //example only
    push: {
	//numpad & dirpad
	send_command dvTP, "'^BMF-108.122,0,%CB#', format('%02X', color[1][1]), format('%02X', color[1][2]), format('%02X', color[1][3]),  //border
	    '%CF#', format('%02X', color[4][1]), format('%02X', color[4][2]), format('%02X', color[4][3]),	//fill
	    '%CT#', format('%02X', color[8][1]), format('%02X', color[8][2]), format('%02X', color[8][3]),	//text
	    '%EC#', format('%02X', color[7][1]), format('%02X', color[7][2]), format('%02X', color[7][3])"	//text effect
	//side bar
	send_command dvTP, "'^BMF-101.107,0,%CB#', format('%02X', color[2][1]), format('%02X', color[2][2]), format('%02X', color[2][3]),  //border
	    '%CF#', format('%02X', color[1][1]), format('%02X', color[1][2]), format('%02X', color[1][3]),	//fill
	    '%CT#', format('%02X', color[8][1]), format('%02X', color[8][2]), format('%02X', color[8][3]),	//text
	    '%EC#', format('%02X', color[7][1]), format('%02X', color[7][2]), format('%02X', color[7][3])"	//text effect
	//background
	send_command dvTP, "'^BMF-100,0,%CB#', format('%02X', color[4][1]), format('%02X', color[4][2]), format('%02X', color[4][3]),  //border
	    '%CF#', format('%02X', color[6][1]), format('%02X', color[6][2]), format('%02X', color[6][3]),	//fill
	    '%CT#', format('%02X', color[8][1]), format('%02X', color[8][2]), format('%02X', color[8][3]),	//text
	    '%EC#', format('%02X', color[7][1]), format('%02X', color[7][2]), format('%02X', color[7][3])"	//text effect
	//transport container
	send_command dvTP, "'^BMF-124,0,%CB#', format('%02X', color[4][1]), format('%02X', color[4][2]), format('%02X', color[4][3]),  //border
	    '%CF#', format('%02X', color[5][1]), format('%02X', color[5][2]), format('%02X', color[5][3]),	//fill
	    '%CT#', format('%02X', color[8][1]), format('%02X', color[8][2]), format('%02X', color[8][3]),	//text
	    '%EC#', format('%02X', color[7][1]), format('%02X', color[7][2]), format('%02X', color[7][3])"	//text effect
	//titles
	send_command dvTP, "'^BMF-123&125,0,%CT#', format('%02X', color[8][1]), format('%02X', color[8][2]), format('%02X', color[8][3]),	//text
	    '%EC#', format('%02X', color[7][1]), format('%02X', color[7][2]), format('%02X', color[7][3])"	//text effect
    }
}

(*****************************************)
(*  Hue, Saturation, & Value to RGB      *)
(*  Usage: f_h2r(hue, saturation, value) *)
(*  Returns integer 1 on success         *)
(*  RGBs are "returned" in h2rReturn     *)
(*  TODO: Can functions return arrays?   *)
(*****************************************)
define_function integer f_h2r(float fh2r[3]) {
    stack_var float h2r[3]
    stack_var float f
    stack_var float p
    stack_var float q
    stack_var float t
    if(fh2r[2]==0) {
	h2rReturn[1]=type_cast((fh2r[3]*2.55) + 0.5)
	h2rReturn[2]=type_cast((fh2r[3]*2.55) + 0.5)
	h2rReturn[3]=type_cast((fh2r[3]*2.55) + 0.5)
	if((h2rReturn[1] >= 0 && h2rReturn[1] <= 255) && (h2rReturn[2] >= 0 && h2rReturn[2] <= 255) && (h2rReturn[3] >= 0 && h2rReturn[3] <= 255))
	    return 1
	else
	    return 0
    }
    fh2r[2]=fh2r[2]/100
    fh2r[3]=fh2r[3]/100
    fh2r[1]=fh2r[1]/60
    i=type_cast(fh2r[1])  //round to but not higher
    f=fh2r[1]-i
    p=fh2r[3]*(1-fh2r[2])
    q=fh2r[3]*(1-fh2r[2]*f)
    t=fh2r[3]*(1-fh2r[2]*(1-f))
    switch(i) {
	case 0: {
	    h2r[1]=fh2r[3]
	    h2r[2]=t
	    h2r[3]=p
	    break
	}
	case 1: {
	    h2r[1]=q
	    h2r[2]=fh2r[3]
	    h2r[3]=p
	    break
	}
	case 2: {
	    h2r[1]=p;
	    h2r[2]=fh2r[3];
	    h2r[3]=t;
	    break
	}
	case 3: {
	    h2r[1]=p
	    h2r[2]=q
	    h2r[3]=fh2r[3]
	    break
	}
	case 4: {
	    h2r[1]=t
	    h2r[2]=p
	    h2r[3]=fh2r[3]
	    break
	}
	default: {
	    h2r[1]=fh2r[3]
	    h2r[2]=p
	    h2r[3]=q
	}
    }
    h2rReturn[1]=type_cast((h2r[1]*255) + 0.5)  //round
    h2rReturn[2]=type_cast((h2r[2]*255) + 0.5)  //round
    h2rReturn[3]=type_cast((h2r[3]*255) + 0.5)  //round
    if((h2rReturn[1] >= 0 && h2rReturn[1] <= 255) && (h2rReturn[2] >= 0 && h2rReturn[2] <= 255) && (h2rReturn[3] >= 0 && h2rReturn[3] <= 255))
	return 1
    else
	return 0
}

(****************************************)
(*  RGB to Hue, Saturation, & Value     *)
(*  Usage: f_r2h(red, green, blue)      *)
(*  Returns integer 1 on success        *)
(*  HSVs are "returned" in r2hReturn    *)
(*  TODO: Can functions return arrays?  *)
(****************************************)
define_function integer f_r2h(float fr2h[3]) {
    stack_var float r2h[3]
    stack_var float m
    stack_var float v
    stack_var float value
    stack_var float delta
    m=fr2h[1]
    if(fr2h[2]<m) m=fr2h[2]
    if(fr2h[3]<m) m=fr2h[3]
    v=fr2h[1]
    if(fr2h[2]>v) v=fr2h[2]
    if(fr2h[3]>v) v=fr2h[3]
    value=100*v/255
    delta=v-m
    if(v==0.0) r2h[2]=0 else r2h[2]=100*delta/v
    if(r2h[2]==0) {
	r2h[1]=0
    } else {
	if(fr2h[1]==v) {
	    r2h[1]=(60*(fr2h[2]-fr2h[3]))/delta
	} else if(fr2h[2]==v) {
	    r2h[1]=120+((60*(fr2h[3]-fr2h[1]))/delta)
	} else if(fr2h[3]=v) {
	    r2h[1]=240+((60*(fr2h[1]-fr2h[2]))/delta)
	}
	if(r2h[1]<0.0) r2h[1]=r2h[1]+360
    }
    r2hReturn[1] = type_cast(r2h[1] + 0.5)
    r2hReturn[2] = type_cast(r2h[2])
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
    stack_var float p[3]
    stack_var float y[3]
    stack_var float pr[3]
    stack_var float yx[3]
    stack_var float x[3]
    color[1] = dom
    uButton(1)
    x[1] = type_cast(dom[1])
    x[2] = type_cast(dom[2])	//kinda ugly..
    x[3] = type_cast(dom[3])	//can't type_cast arrays
    f_r2h(x)
    y[2] = r2hReturn[2]
    p[2] = y[2]
    y[1] = r2hReturn[1]
    p[1] = y[1]
    if(r2hReturn[3] > 70) {
	y[3] = r2hReturn[3] - 30
	p[3] = y[3] + 15
    } else {
	y[3] = r2hReturn[3] + 30
	p[3] = y[3] - 15
    }

    f_h2r(p)
    color[2] = h2rReturn
    uButton(2)

    f_h2r(y)
    color[3] = h2rReturn
    uButton(3)

    if(r2hReturn[1] >= 0 && r2hReturn[1] < 30) {
	pr[1] = r2hReturn[1] + 20
	yx[1] = r2hReturn[1] + 20
	y[1] = r2hReturn[1] + 20
	pr[2] = r2hReturn[2]
	yx[2] = r2hReturn[2]
	y[2] = r2hReturn[2]
	y[3] = r2hReturn[3]
	if(r2hReturn[3] > 70 ) {
	    yx[3] = r2hReturn[3] - 30
	    pr[3] = yx[3] + 15
	} else {
	    yx[3] = r2hReturn[3] + 30
	    pr[3] = yx[3] - 15
	}
    }
    if(r2hReturn[1] >= 30 && r2hReturn[1] < 60) {
	pr[1] = r2hReturn[1] + 150
	yx[1] = r2hReturn[1] + 150
	y[1] = r2hReturn[1] + 150
	y[2] = rc(r2hReturn[1] - 30, 100)
	y[3] = rc(r2hReturn[3] - 20, 100)
	yx[2] = rc(r2hReturn[2] - 70, 100)
	pr[2] = rc(r2hReturn[2] - 70, 100)
	yx[3] = rc(r2hReturn[3] + 20, 100)
	pr[3] = r2hReturn[3]
    }
    if(r2hReturn[1] >= 60 && r2hReturn[1] < 180) {
	pr[1] = r2hReturn[1] - 40
	yx[1] = r2hReturn[1] - 40
	y[1] = r2hReturn[1] - 40
	pr[2] = r2hReturn[2]
	y[2] = r2hReturn[2]
	yx[2] = r2hReturn[2]
	y[3] = r2hReturn[3]
	if(r2hReturn[3] > 70) {
	    yx[3] = r2hReturn[3] - 30
	    pr[3] = yx[3] + 15
	} else {
	    yx[3] = r2hReturn[3] + 30
	    pr[3] = yx[3] - 15
	}
    }
    if(r2hReturn[1] >= 180 && r2hReturn[1] < 220) {
	pr[1] = r2hReturn[1] - 170
	yx[1] = r2hReturn[1] - 170
	y[1] = r2hReturn[1] - 160
	pr[2] = r2hReturn[2]
	yx[2] = r2hReturn[2]
	y[2] = r2hReturn[2]
	y[3] = r2hReturn[3]
	if(r2hReturn[3] > 70) {
	    yx[3] = r2hReturn[3] - 30
	    pr[3] = yx[3] + 15
	} else {
	    yx[3] = r2hReturn[3] + 30
	    pr[3] = yx[3] - 15
	}
    }
    if(r2hReturn[1] >= 220 && r2hReturn[1] < 300) {
	pr[1] = r2hReturn[1]
	yx[1] = r2hReturn[1]
	y[1] = r2hReturn[1]
	pr[2] = rc(r2hReturn[2] - 60, 100)
	yx[2] = pr[2]
	y[2] = yx[2]
	y[3] = r2hReturn[3]
	if(r2hReturn[3] > 70) {
	    yx[3] = r2hReturn[3] - 30
	    pr[3] = yx[3] + 15
	} else {
	    yx[3] = r2hReturn[3] + 30
	    pr[3] = yx[3] - 15
	}
    }
    if(r2hReturn[1] >= 300) {
	if(r2hReturn[2] > 50) {
	    pr[2] = r2hReturn[2] - 40
	} else {
	    pr[2] = r2hReturn[2] + 40
	}
	y[2] = pr[2]
	yx[2] = y[2]
	pr[1] = (r2hReturn[1] + 20) % 360
	y[1] = pr[1]
	yx[1] = y[1]
	y[3] = r2hReturn[3]
	if(r2hReturn[3] > 70) {
	    yx[3] = r2hReturn[3] - 30
	    pr[3] = yx[3] + 15
	} else {
	    yx[3] = r2hReturn[3] + 30
	    pr[3] = yx[3] - 15
	}
    }

    f_h2r(y)
    color[4] = h2rReturn
    uButton(4)

    f_h2r(yx)
    color[6] = h2rReturn
    uButton(6)

    y[1]=0
    y[2]=0
    y[3]=100-r2hReturn[3]
    f_h2r(y)
    color[7] = h2rReturn
    uButton(7)

    y[1]=0
    y[2]=0
    y[3]=r2hReturn[3]
    f_h2r(y)
    color[8] = h2rReturn
    uButton(8)

    f_h2r(pr)
    color[5] = h2rReturn
    uButton(5)
}

define_function uButton (integer colorNum) {
    send_command dvTP, "'^BCF-', itoa(colorNum + 9) ,',0,#', format('%02X', color[colorNum][1]), format('%02X', color[colorNum][2]), format('%02X', color[colorNum][3])" 
    send_command dvTP, "'^BMF-', itoa(colorNum + 19) ,',0,%T#', format('%02X', color[colorNum][1]), format('%02X', color[colorNum][2]), format('%02X', color[colorNum][3])" 
}
