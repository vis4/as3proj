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
	
	public class MBTFPQProjection extends Projection
	{
		private static const NITER:int = 20;
		private static const EPS:Number = 1e-7;
		private static const ONETOL:Number = 1.000001;
		private static const C:Number = 1.70710678118654752440;
		private static const RC:Number = 0.58578643762690495119;
		private static const FYC:Number = 1.87475828462269495505;
		private static const RYC:Number = 0.53340209679417701685;
		private static const FXC:Number = 0.31245971410378249250;
		private static const RXC:Number = 3.20041258076506210122;
		
		override public function project(lplam:Number, lpphi:Number, out:Point):Point 
		{
			var th1:Number, c:Number, i:int;

			c = C * Math.sin(lpphi);
			for (i = NITER; i > 0; --i) {
				out.y -= th1 = (Math.sin(.5*lpphi) + Math.sin(lpphi) - c) /
					(.5*Math.cos(.5*lpphi)  + Math.cos(lpphi));
				if (Math.abs(th1) < EPS) break;
			}
			out.x = FXC * lplam * (1.0 + 2. * Math.cos(lpphi)/Math.cos(0.5 * lpphi));
			out.y = FYC * Math.sin(0.5 * lpphi);
			return out;
		}
		
		override public function projectInverse(xyx:Number, xyy:Number, out:Point):Point 
		{
			var t:Number = 0, lpphi:Number = RYC * xyy;
			
			if (Math.abs(lpphi) > 1.) {
				if (Math.abs(lpphi) > ONETOL)	throw new ProjectionError("I");
				else if (lpphi < 0.) { t = -1.; lpphi = -Math.PI; }
				else { t = 1.; lpphi = Math.PI; }
			} else
				lpphi = 2. * Math.asin(t = lpphi);
			out.x = RXC * xyx / (1. + 2. * Math.cos(lpphi)/Math.cos(0.5 * lpphi));
			lpphi = RC * (t + Math.sin(lpphi));
			if (Math.abs(lpphi) > 1.)
				if (Math.abs(lpphi) > ONETOL)
					throw new ProjectionError("I");
				else
					lpphi = lpphi < 0. ? -MapMath.HALFPI : MapMath.HALFPI;
			else
				lpphi = Math.asin(lpphi);
			out.y = lpphi;
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
			return "McBryde-Thomas Flat-Polar Quartic";
		}
		
		override public function get shortName():String { return "MBTFPQ"; }
		
		
	}

}