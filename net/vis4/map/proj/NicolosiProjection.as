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
	
	public class NicolosiProjection extends Projection
	{
		
		private static const EPS:Number = 1e-10;
		
		override public function project(lplam:Number, lpphi:Number, out:Point):Point 
		{
			if (Math.abs(lplam) < EPS) {
				out.x = 0;
				out.y = lpphi;
			} else if (Math.abs(lpphi) < EPS) {
				out.x = lplam;
				out.y = 0.;
			} else if (Math.abs(Math.abs(lplam) - MapMath.HALFPI) < EPS) {
				out.x = lplam * Math.cos(lpphi);
				out.y = MapMath.HALFPI * Math.sin(lpphi);
			} else if (Math.abs(Math.abs(lpphi) - MapMath.HALFPI) < EPS) {
				out.x = 0;
				out.y = lpphi;
			} else {
				var tb:Number, c:Number, d:Number, m:Number, n:Number, r2:Number, sp:Number;

				tb = MapMath.HALFPI / lplam - lplam / MapMath.HALFPI;
				c = lpphi / MapMath.HALFPI;
				d = (1 - c * c)/((sp = Math.sin(lpphi)) - c);
				r2 = tb / d;
				r2 *= r2;
				m = (tb * sp / d - 0.5 * tb)/(1. + r2);
				n = (sp / r2 + 0.5 * d)/(1. + 1./r2);
				var x:Number = Math.cos(lpphi);
				x = Math.sqrt(m * m + x * x / (1. + r2));
				out.x = MapMath.HALFPI * ( m + (lplam < 0. ? -x : x));
				var y:Number = Math.sqrt(n * n - (sp * sp / r2 + d * sp - 1.) /
					(1. + 1./r2));
				out.y = MapMath.HALFPI * ( n + (lpphi < 0. ? y : -y ));
			}
			return out;
		}
		
		override public function toString():String 
		{
			return "Nicolosi Globular";
		}
		
		override public function get shortName():String { return "Nicolosi"; }
		
	}

}