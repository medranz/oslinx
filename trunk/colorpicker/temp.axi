PROGRAM_NAME='temp'

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


