program_name='Main'

define_variable

volatile float hsS
volatile float hsV
volatile float hsH

volatile float h2rR
volatile float h2rG
volatile float h2rB

//var hs=new Object();
//var rg=new Object();

//function c2r(d)
//{
//	k=document.getElementById(d).style.backgroundColor;
//	j=(k.substr(4,k.indexOf(")")-4)).split(",");
//	r.setValue(j[0]);
//	g.setValue(j[1]);
//	b.setValue(j[2]);
//}
//function load_theme()
//{
//	sel = document.getElementById("coltheme");
//	var d = sel.options[sel.selectedIndex].value;
//	j=d.split(",");
//	r.setValue(j[0]);
//	g.setValue(j[1]);
//	b.setValue(j[2]);
//}
//
//function ud(x,c)
//{
//	document.getElementById("sw"+x).style.backgroundColor="rgb("+c.r+","+c.g+","+c.b+")";
//	document.getElementById("hc"+x).innerHTML=rg2html(c) + "<br />R: "+c.r+"<br />G: "+c.g+"<br />B: "+c.b;
//	document.getElementById("col"+x).value="#"+rg2html(c)
//}
//function rg2html(z)
//{
//	return d2h(z.r)+d2h(z.g)+d2h(z.b);
//}
//function d2h(d)
//{
//	hch="0123456789ABCDEF";
//	a=d%16;
//	q=(d-a)/16;
//	return hch.charAt(q)+hch.charAt(a);
//}

define_function integer h2r() {
    stack_var float i
    stack_var float f
    stack_var float p  //should be integers?
    stack_var float q
    stack_var float t
    if(hsS==0) {
	h2rR=(hsV*2.55) //round?
	h2rG=(hsV*2.55) //round?
	h2rB=(hsV*2.55) //round?
	return 1
    }
    hsS=hsS/100
    hsV=hsV/100
    hsH=hsH/60
    i=hsH  //round to but not higher
    f=hsH-i
    p=hsV*(1-hsS)
    q=hsV*(1-hsS*f)
    t=hsV*(1-hsS*(1-f))
    switch(i) {
	case 0: {
	    h2rR=hsV
	    h2rG=t
	    h2rB=p
	    break
	}
	case 1: {
	    h2rR=q
	    h2rG=hsV
	    h2rB=p
	    break
	}
	case 2: {
	    h2rR=p;
	    h2rG=hsV;
	    h2rB=t;
	    break
	}
	case 3: {
	    h2rR=p
	    h2rG=q
	    h2rB=hsV
	    break
	}
	case 4: {
	    h2rR=t
	    h2rG=p
	    h2rB=hsV
	    break
	}
	default: {
	    h2rR=hsV
	    h2rG=p
	    h2rB=q
	}
    }
    h2rR=h2rR*255  //round
    h2rG=h2rG*255  //round
    h2rB=h2rB*255  //round
    return 1
}

//function rc(x,m)
//{
//	if(x>m)
//	{
//		return m
//	}
//	if(x<0)
//	{
//		return 0
//	}
//	else
//	{
//		return x
//	}
//}

define_function integer rg2hs(integer rgR, integer rgG, integer rgB) {
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
    if(v==0.0) hsS=0 else hsS=100*delta/v
    if(hsS==0) {
	hsH=0
    } else {
	if(rgR==v) {
	    hsH=(60*(rgG-rgB))/delta
	} else if(rgG==v) {
	    hsH=120+((60*(rgB-rgR))/delta)  //operator precedence?
	} else if(rgB=v) {
	    hsH=240+((60*(rgR-rgG))/delta)
	}
	if(hsH<0.0) hsH=hsH+360
    }
    hsV=value //round
    hsH=hsH  //round
    hsS=hsS  //round
    return 1
}

//function dom()
//{
//	z=new Object();
//	y=new Object();
//	yx=new Object();
//	p=new Object();
//	pr=new Object();
//	p.s=y.s=hs.s;
//	p.h=y.h=hs.h;
//	if(hs.v>70)
//	{
//		y.v=hs.v-30
//		p.v=y.v +15
//		z=h2r(p);
//		ud("1",z);
//		
//
//	}
//	else
//	{
//		y.v=hs.v+30
//		p.v=y.v-15
//		z=h2r(p);
//		ud("1",z);
//		
//	};
//	z=h2r(y);
//	ud("2",z);
//	if((hs.h>=0)&&(hs.h<30))
//	{
//		pr.h=yx.h=y.h=hs.h+20;
//		pr.s=yx.s=y.s=hs.s;
//		y.v=hs.v;
//		if(hs.v>70)
//		{
//			yx.v=hs.v-30
//			pr.v = yx.v +15
//		}
//		else
//		{
//			yx.v=hs.v+30
//			pr.v = yx.v -15
//		}
//	}
//	if((hs.h>=30)&&(hs.h<60))
//	{
//		pr.h=yx.h=y.h=hs.h+150;
//		y.s=rc(hs.s-30,100);
//		y.v=rc(hs.v-20,100);
//		pr.s=yx.s=rc(hs.s-70,100);
//		yx.v=rc(hs.v+20,100);
//		pr.v=hs.v
//	}
//	if((hs.h>=60)&&(hs.h<180))
//	{
//		pr.h=yx.h=y.h=hs.h-40;
//		pr.s=y.s=yx.s=hs.s;
//		y.v=hs.v;
//		if(hs.v>70)
//		{
//			yx.v=hs.v-30
//			pr.v = yx.v +15
//		}
//		else
//		{
//			yx.v=hs.v+30
//			pr.v = yx.v -15
//		}
//	}
//	if((hs.h>=180)&&(hs.h<220))
//	{
//		pr.h=yx.h=hs.h-170;
//		y.h=hs.h-160;
//		pr.s=yx.s=y.s=hs.s;
//		y.v=hs.v;
//		if(hs.v>70)
//		{
//			yx.v=hs.v-30
//			pr.v = yx.v +15
//		}
//		else
//		{
//			yx.v=hs.v+30
//			pr.v = yx.v -15
//		}
//	}
//	if((hs.h>=220)&&(hs.h<300))
//	{
//		pr.h=yx.h=y.h=hs.h;
//		pr.s=yx.s=y.s=rc(hs.s-60,100);
//		y.v=hs.v;
//		if(hs.v>70)
//		{
//			yx.v=hs.v-30
//			pr.v = yx.v +15
//		}
//		else
//		{
//			yx.v=hs.v+30
//			pr.v = yx.v -15
//		}
//	}
//	if(hs.h>=300)
//	{
//		if(hs.s>50)
//		{
//			pr.s=y.s=yx.s=hs.s-40
//		}
//		else
//		{
//			pr.s=y.s=yx.s=hs.s+40
//		}
//		pr.h=yx.h=y.h=(hs.h+20)%360;
//		y.v=hs.v;
//		if(hs.v>70)
//		{
//			yx.v=hs.v-30
//			pr.v = yx.v +15
//		}
//		else
//		{
//			yx.v=hs.v+30
//			pr.v = yx.v -15
//		}
//	}
//	z=h2r(y);
//	ud("3",z);
//	z=h2r(yx);
//	ud("5",z);
//	y.h=0;
//	y.s=0;
//	y.v=100-hs.v;
//	z=h2r(y);
//	ud("6",z);
//	y.h=0;
//	y.s=0;
//	y.v=hs.v;
//	z=h2r(y);
//	ud("7",z);
//	z=h2r(pr);
//	ud("4",z);
//	if(hs.v >= 50) { pr.v = 0 } else { pr.v = 100 } 
//	pr.h=pr.s=0;
//	z=h2r(pr);
//	ud("8",z)
//}