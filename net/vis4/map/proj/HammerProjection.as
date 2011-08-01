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
	
	public class HammerProjection extends PseudoCylindricalProjection
	{
		private var _w:Number = 0.5;
		private var _m:Number = 1;
		private var rm:Number;
	
		override public function project(lplam:Number, lpphi:Number, xy:Point):Point 
		{
			var cosphi:Number, d:Number;

			d = Math.sqrt(2./(1. + (cosphi = Math.cos(lpphi)) * Math.cos(lplam *= w)));
			xy.x = m * d * cosphi * Math.sin(lplam);
			xy.y = rm * d * Math.sin(lpphi);
			return xy;
		}
		
		override public function initialize():void 
		{
			super.initialize();
			if ((w = Math.abs(w)) <= 0.)
				throw new ProjectionError("-27");
			else
				w = .5;
			if ((m = Math.abs(m)) <= 0.)
				throw new ProjectionError("-27");
			else
				m = 1.;
			rm = 1. / m;
			m /= w;
			es = 0.;
		}
		
		override public function isEqualArea():Boolean 
		{
			return true;
		}
		
		public function get w():Number { return _w; }
		
		public function set w(value:Number):void 
		{
			_w = value;
		}
		
		public function get m():Number { return _m; }
		
		public function set m(value:Number):void 
		{
			_m = value;
		}
		
		override public function toString():String 
		{
			return "Hammer & Eckert-Greifendorff";
		}
		
		override public function get shortName():String { return "Hammer"; }
		
		
	}

}