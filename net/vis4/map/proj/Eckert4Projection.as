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

	public class Eckert4Projection extends Projection
	{

		private static const C_x:Number = .42223820031577120149;
		private static const C_y:Number = 1.32650042817700232218;
		private static const RC_y:Number = .75386330736002178205;
		private static const C_p:Number = 3.57079632679489661922;
		private static const RC_p:Number = .28004957675577868795;
		private static const EPS:Number = 1e-7;
		private static const NITER:int = 6;
	
		override public function project(lplam:Number, lpphi:Number, out:Point):Point 
		{
			var p:Number, V:Number, s:Number, c:Number, i:int;

			p = C_p * Math.sin(lpphi);
			V = lpphi * lpphi;
			lpphi *= 0.895168 + V * ( 0.0218849 + V * 0.00826809 );
			for (i = NITER; i > 0; --i) {
				c = Math.cos(lpphi);
				s = Math.sin(lpphi);
				lpphi -= V = (lpphi + s * (c + 2.) - p) /
					(1. + c * (c + 2.) - s * s);
				if (Math.abs(V) < EPS)
					break;
			}
			if (i == 0) {
				out.x = C_x * lplam;
				out.y = lpphi < 0. ? -C_y : C_y;
			} else {
				out.x = C_x * lplam * (1. + Math.cos(lpphi));
				out.y = C_y * Math.sin(lpphi);
			}
			return out;
		}
		
		override public function projectInverse(xyx:Number, xyy:Number, out:Point):Point 
		{
			var c:Number;

			out.y = MapMath.asin(xyy / C_y);
			out.x = xyx / (C_x * (1. + (c = Math.cos(out.y))));
			out.y = MapMath.asin((out.y + Math.sin(out.y) * (c + 2.)) / C_p);
			return out;
		}
		
		override public function parallelsAreParallel():Boolean 
		{
			return true;
		}
		
		override public function hasInverse():Boolean 
		{
			return true;
		}
		
		override public function toString():String 
		{
			return "Eckert IV";
		}
	}

}