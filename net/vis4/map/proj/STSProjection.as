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
	import net.vis4.map.MapMath;
	
	public class STSProjection extends ConicProjection
	{
		
		private var C_x:Number;
		private var C_y:Number;
		private var C_p:Number;
		private var tan_mode:Boolean;
	
		public function STSProjection(p:Number, q:Number, mode:Boolean) 
		{
			es = 0.;
			C_x = q / p;
			C_y = p;
			C_p = 1/ q;
			tan_mode = mode;
			initialize();
		}
		
		override public function project(lplam:Number, lpphi:Number, xy:Point):Point 
		{
			var c:Number;

			xy.x = C_x * lplam * Math.cos(lpphi);
			xy.y = C_y;
			lpphi *= C_p;
			c = Math.cos(lpphi);
			if (tan_mode) {
				xy.x *= c * c;
				xy.y *= Math.tan(lpphi);
			} else {
				xy.x /= c;
				xy.y *= Math.sin(lpphi);
			}
			return xy;
		}
		
		override public function projectInverse(xyx:Number, xyy:Number, lp:Point):Point 
		{
			var c:Number;
		
			xyy /= C_y;
			c = Math.cos(lp.y = tan_mode ? Math.atan(xyy) : MapMath.asin(xyy));
			lp.y /= C_p;
			lp.x = xyx / (C_x * Math.cos(lp.y /= C_p));
			if (tan_mode)
				lp.x /= c * c;
			else
				lp.x *= c;
			return lp;
		}
		
		override public function hasInverse():Boolean 
		{
			return true;
		}
	}

}