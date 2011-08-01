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
	import net.vis4.map.proj.Projection;
	
	public class NellHProjection extends Projection
	{
		private static const NITER:int = 9;
		private static const EPS:Number = 1e-7;
	
		override public function project(lplam:Number, lpphi:Number, out:Point):Point 
		{
			out.x = 0.5 * lplam * (1. + Math.cos(lpphi));
			out.y = 2.0 * (lpphi - Math.tan(0.5 *lpphi));
			return out;
		}
		
		override public function projectInverse(xyx:Number, xyy:Number, out:Point):Point 
		{
			var V:Number, c:Number, p:Number, i:int;
			
			p = 0.5 * xyy;
			for (i = NITER; i > 0 ; --i) {
				c = Math.cos(0.5 * xyy);
				out.y -= V = (xyy - Math.tan(xyy/2) - p)/(1. - 0.5/(c*c));
				if (Math.abs(V) < EPS)
					break;
			}
			if (i == 0) {
				out.y = p < 0. ? -MapMath.HALFPI : MapMath.HALFPI;
				out.x = 2. * xyx;
			} else
				out.x = 2. * xyx / (1. + Math.cos(xyy));
			return out;
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
			return "Nell-Hammer";
		}
		
		override public function get inventor():String { return "Ernst Hammer"; }
		override public function get year():int { return 1900; }
	}

}