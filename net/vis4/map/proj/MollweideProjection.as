/*
Copyright 2006 Jerry Huxtable

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

/*
 * This file was semi-automatically converted from the public-domain USGS PROJ source.
 */

/*
 * This file was manually ported to actionscript by Gregor Aisch, vis4.net
 */

package net.vis4.map.proj 
{
	import flash.geom.Point;
	
	public class MollweideProjection extends PseudoCylindricalProjection
	{
		public static const MOLLWEIDE:int = 0;
		public static const WAGNER4:int = 1;
		public static const WAGNER5:int = 2;
		
		private static const MAX_ITER:int = 10;
		private static const TOLERANCE:Number = 1e-7;
		
		private var type:int = MOLLWEIDE;
		private var cx:Number, cy:Number, cp:Number;
		
		public function MollweideProjection(type:int = MOLLWEIDE) 
		{
			this.type = type;
			switch (type) {
			case MOLLWEIDE:
				init(Math.PI/2);
				break;
			case WAGNER4:
				init(Math.PI/3);
				break;
			case WAGNER5:
				init(Math.PI/2);
				cx = 0.90977;
				cy = 1.65014;
				cp = 3.00896;
				break;
			}
		}
		
		private function init(p:Number):void
		{
			var r:Number, sp:Number, p2:Number = p + p;

			sp = Math.sin(p);
			r = Math.sqrt(Math.PI*2.0 * sp / (p2 + Math.sin(p2)));
			cx = 2. * r / Math.PI;
			cy = r / sp;
			cp = p2 + Math.sin(p2);
		}
		
		/*
		 * work-around for multiple constructors
		 */
		public static function fromP(p:Number):MollweideProjection
		{
			var m:MollweideProjection = new MollweideProjection();
			m.init(p);
			return m;
		}
		
		/*
		 * work-around for multiple constructors
		 */
		public static function fromCxCyCp(cx:Number, cy:Number, cp:Number):MollweideProjection
		{
			var m:MollweideProjection = new MollweideProjection();
			m.cx = cx;
			m.cy = cy;
			m.cp = cp;
			return m;
		}
		
		override public function project(lplam:Number, lpphi:Number, xy:Point):Point 
		{
			var k:Number, v:Number, i:int;
			
			k = cp * Math.sin(lpphi);
			for (i = MAX_ITER; i != 0; i--) {
				lpphi -= v = (lpphi + Math.sin(lpphi) - k) / (1. + Math.cos(lpphi));
				if (Math.abs(v) < TOLERANCE)
					break;
			}
			if (i == 0)
				lpphi = (lpphi < 0.) ? -Math.PI/2 : Math.PI/2;
			else
				lpphi *= 0.5;
			xy.x = cx * lplam * Math.cos(lpphi);
			xy.y = cy * Math.sin(lpphi);
			return xy;
		}
		
		override public function projectInverse(x:Number, y:Number, lp:Point):Point 
		{
			var lat:Number, lon:Number;
			
			lat = Math.asin(y / cy);
			lon = x / (cx * Math.cos(lat));
			lat += lat;
			lat = Math.asin((lat + Math.sin(lat)) / cp);
			lp.x = lon;
			lp.y = lat;
			return lp;
		}
		
		override public function hasInverse():Boolean 
		{
			return true;
		}
		
		override public function isEqualArea():Boolean 
		{
			return type == MOLLWEIDE;
		}
		
		override public function parallelsAreParallel():Boolean 
		{
			return true;
		}
		
		override public function toString():String 
		{
			switch (type) {
			case WAGNER4:
				return "Wagner IV";
			case WAGNER5:
				return "Wagner V";
			}
			return "Mollweide";
		}
		
	}

}