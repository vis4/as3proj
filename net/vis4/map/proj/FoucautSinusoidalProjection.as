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
	
	public class FoucautSinusoidalProjection extends Projection
	{
			
		private var n:Number = 0, n1:Number = 0;

		private static const MAX_ITER:int = 10;
		private static const LOOP_TOL:Number = 1e-7;

		override public function project(lplam:Number, lpphi:Number, out:Point):Point 
		{
			var t:Number;
			t = Math.cos(lpphi);
			out.x = lplam * t / (n + n1 * t);
			out.y = n * lpphi + n1 * Math.sin(lpphi);
			return out;
		}
		
		override public function projectInverse(xyx:Number, xyy:Number, out:Point):Point 
		{
			var V:Number, i:int;
			
			if (n != 0) {
				out.y = xyy;
				for (i = MAX_ITER; i > 0; --i) {
					out.y -= V = (n * out.y + n1 * Math.sin(out.y) - xyy ) /
						(n + n1 * Math.cos(out.y));
					if (Math.abs(V) < LOOP_TOL)
						break;
				}
				if (i == 0)
					out.y = xyy < 0. ? -MapMath.HALFPI : MapMath.HALFPI;
			} else
				out.y = MapMath.asin(xyy);
			V = Math.cos(out.y);
			out.x = xyx * (n + n1 * V) / V;
			return out;
		}
		
		override public function initialize():void 
		{
			super.initialize();
	//		n = pj_param(params, "dn").f;
			if (n < 0. || n > 1.)
				throw new ProjectionError("-99");
			n1 = 1. - n;
		}

		override public function hasInverse():Boolean 
		{
			return true;
		}
		
		override public function isRectilinear():Boolean 
		{
			return true;
		}
			
		override public function toString():String 
		{
			return "Foucaut Sinusoidal";
		}

		override public function get shortName():String { return "Foucaut"; }
	}

}