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
	
	public class CassiniProjection extends Projection
	{
		private var m0:Number;
		private var n:Number;
		private var t:Number;
		private var a1:Number;
		private var c:Number;
		private var r:Number;
		private var dd:Number;
		private var d2:Number;
		private var a2:Number;
		private var tn:Number;
		private var en:Array;

		private static const EPS10:Number = 1e-10;
		private static const C1:Number = .16666666666666666666;
		private static const C2:Number = .00833333333333333333;
		private static const C3:Number = .04166666666666666666;
		private static const C4:Number = .33333333333333333333;
		private static const C5:Number = .06666666666666666666;

		public function CassiniProjection()
		{
			projectionLatitude = MapMath.toRadians(0);
			projectionLongitude = MapMath.toRadians(0);
			minLongitude = MapMath.toRadians(-90);
			maxLongitude = MapMath.toRadians(90);
			initialize();
		}

		override public function project(lplam:Number, lpphi:Number, xy:Point):Point
		{
			if (spherical) {
				xy.x = Math.asin(Math.cos(lpphi) * Math.sin(lplam));
				xy.y = Math.atan2(Math.tan(lpphi) , Math.cos(lplam)) - projectionLatitude;
			} else {
				xy.y = MapMath.mlfn(lpphi, n = Math.sin(lpphi), c = Math.cos(lpphi), en);
				n = 1./Math.sqrt(1. - es * n * n);
				tn = Math.tan(lpphi); t = tn * tn;
				a1 = lplam * c;
				c *= es * c / (1 - es);
				a2 = a1 * a1;
				xy.x = n * a1 * (1. - a2 * t *
				(C1 - (8. - t + 8. * c) * a2 * C2));
				xy.y -= m0 - n * tn * a2 *
				(.5 + (5. - t + 6. * c) * a2 * C3);
			}
			return xy;
		}

		override public function projectInverse(xyx:Number, xyy:Number, out:Point):Point
		{
			if (spherical) {
				out.y = Math.asin(Math.sin(dd = xyy + projectionLatitude) * Math.cos(xyx));
				out.x = Math.atan2(Math.tan(xyx), Math.cos(dd));
			} else {
				var ph1:Number;

				ph1 = MapMath.inv_mlfn(m0 + xyy, es, en);
				tn = Math.tan(ph1); t = tn * tn;
				n = Math.sin(ph1);
				r = 1. / (1. - es * n * n);
				n = Math.sqrt(r);
				r *= (1. - es) * n;
				dd = xyx / n;
				d2 = dd * dd;
				out.y = ph1 - (n * tn / r) * d2 *
				(.5 - (1. + 3. * t) * d2 * C3);
				out.x = dd * (1. + t * d2 *
				(-C4 + (1. + 3. * t) * d2 * C5)) / Math.cos(ph1);
			}
			return out;
		}

		override public function initialize():void
		{
			super.initialize();
			if (!spherical) {
				if ((en = MapMath.enfn(es)) == null)
				throw new ArgumentError();
				m0 = MapMath.mlfn(projectionLatitude, Math.sin(projectionLatitude), Math.cos(projectionLatitude), en);
			}
		}
		
		override public function hasInverse():Boolean 
		{
			return true;
		}
		
		override public function getEPSGCode():int 
		{
			return 9806;
		}
		
		override public function toString():String 
		{
			return "Cassini";
		}

	}

}

