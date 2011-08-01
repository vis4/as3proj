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
	import net.vis4.map.proj.PseudoCylindricalProjection;
	
	public class AitoffProjection extends PseudoCylindricalProjection
	{
		protected static const AITOFF:int = 0;
		protected static const WINKEL:int = 1;

		private var winkel:Boolean = false;
		private var cosphi1:Number = 0;
		
		public function AitoffProjection(type:int = 0, projectionLatitude:Number = 0) 
		{
			super();
			winkel = type == WINKEL;
			this.projectionLatitude = projectionLatitude;
		}
		
		override public function project(lplam:Number, lpphi:Number, out:Point):Point 
		{
			var c:Number = 0.5 * lplam;
			var d:Number  = Math.acos(Math.cos(lpphi) * Math.cos(c));

			if (d != 0) {
				out.x = 2. * d * Math.cos(lpphi) * Math.sin(c) * (out.y = 1. / Math.sin(d));
				out.y *= d * Math.sin(lpphi);
			} else
				out.x = out.y = 0.0;
			if (winkel) {
				out.x = (out.x + lplam * cosphi1) * 0.5;
				out.y = (out.y + lpphi) * 0.5;
			}
			return out;
		}
		
		override public function initialize():void 
		{
			super.initialize();
			if (winkel) {
				cosphi1 = 0.636619772367581343;
			}
		}
		
		override public function hasInverse():Boolean 
		{
			return false;
		}
		
		override public function toString():String 
		{
			return winkel ? "Winkel Tripel" : "Aitoff";
		}
		
		override public function get shortName():String { return winkel ? "Winkel III" : "Aitoff"; }
		override public function get inventor():String { return winkel ? "Oswald Winkel" : "David Aitoff"; }
		override public function get year():int { return winkel ? 1921 : 1889; }
		
		
		
	}

}