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
	
	public class GallProjection extends Projection
	{
		private static const YF:Number = 1.70710678118654752440;
		private static const XF:Number = 0.70710678118654752440;
		private static const RYF:Number = 0.58578643762690495119;
		private static const RXF:Number = 1.41421356237309504880;
	
		override public function project(lplam:Number, lpphi:Number, out:Point):Point 
		{
			out.x = XF * lplam;
			out.y = YF * Math.tan(.5 * lpphi);
			return out;
		}
		
		override public function projectInverse(xyx:Number, xyy:Number, out:Point):Point 
		{
			out.x = RXF * xyx;
			out.y = 2. * Math.atan(xyy * RYF);
			return out;
		}
		
		override public function hasInverse():Boolean 
		{
			return true;
		}
		
		override public function toString():String 
		{
			return "Gall Stereographic";
		}
		
		override public function isRectilinear():Boolean 
		{
			return true;
		}
		
		override public function get shortName():String { return "Gall"; }
		override public function get inventor():String { return "James Gall"; }
		override public function get year():int { return 1855; }
		
	}

}