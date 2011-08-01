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
	
	public class TCEAProjection extends Projection
	{
		
		private var rk0:Number;
		
		public function TCEAProjection() 
		{
			initialize();
		}
		
		override public function project(lplam:Number, lpphi:Number, out:Point):Point 
		{
			out.x = rk0 * Math.cos(lpphi) * Math.sin(lplam);
			out.y = scaleFactor * (Math.atan2(Math.tan(lpphi), Math.cos(lplam)) - projectionLatitude);
			return out;
		}
		
		override public function projectInverse(xyx:Number, xyy:Number, out:Point):Point 
		{
			var t:Number;

			out.y = xyy * rk0 + projectionLatitude;
			out.x *= scaleFactor;
			t = Math.sqrt(1. - xyx * xyx);
			out.y = Math.asin(t * Math.sin(xyy));
			out.x = Math.atan2(xyx, t * Math.cos(xyy));
			return out;
		}
		
		override public function initialize():void 
		{
			super.initialize();
			rk0 = 1 / scaleFactor;
		}
		
		override public function hasInverse():Boolean 
		{
			return true;
		}
		
		override public function toString():String 
		{
			return "Transverse Cylindrical Equal Area";
		}
		
		override public function get shortName():String { return "TCEA"; }
		
		override public function isEqualArea():Boolean 
		{
			return true;
		}
		
	}

}