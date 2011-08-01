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
	
	public class FaheyProjection extends Projection
	{
		private static const TOL:Number = 1e-6;
		
		override public function project(lplam:Number, lpphi:Number, out:Point):Point 
		{
			out.y = 1.819152 * ( out.x = Math.tan(0.5 * lpphi) );
			out.x = 0.819152 * lplam * asqrt(1 - out.x * out.x);
			return out;
		}
		
		override public function projectInverse(xyx:Number, xyy:Number, out:Point):Point 
		{
			out.y = 2. * Math.atan(out.y /= 1.819152);
			out.x = Math.abs(out.y = 1. - xyy * xyy) < TOL ? 0. :
				xyx / (0.819152 * Math.sqrt(xyy));
			return out;
		}
		
		private function asqrt(v:Number):Number
		{
			return (v <= 0) ? 0. : Math.sqrt(v);
		}
		
		override public function hasInverse():Boolean 
		{
			return true;
		}
		
		override public function parallelsAreParallel():Boolean 
		{
			return true;
		}
		
		override public function toString():String 
		{
			return "Fahey";
		}
		
	}

}