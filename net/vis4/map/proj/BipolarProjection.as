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

	public class BipolarProjection extends Projection
	{
		private var	noskew:Boolean;

		private static const EPS:Number = 1e-10;
		private static const EPS10:Number = 1e-10;
		private static const ONEEPS:Number = 1.000000001;
		private static const NITER:int = 10;
		private static const lamB:Number = -.34894976726250681539;
		private static const n:Number = .63055844881274687180;
		private static const F:Number = 1.89724742567461030582;
		private static const Azab:Number = .81650043674686363166;
		private static const Azba:Number = 1.82261843856185925133;
		private static const T:Number = 1.27246578267089012270;
		private static const rhoc:Number = 1.20709121521568721927;
		private static const cAzc:Number = .69691523038678375519;
		private static const sAzc:Number = .71715351331143607555;
		private static const C45:Number = .70710678118654752469;
		private static const S45:Number = .70710678118654752410;
		private static const C20:Number = .93969262078590838411;
		private static const S20:Number = -.34202014332566873287;
		private static const R110:Number = 1.91986217719376253360;
		private static const R104:Number = 1.81514242207410275904;

		public function BipolarProjection()
		{
			minLatitude = MapMath.toRadians(-80);
			maxLatitude = MapMath.toRadians(80);
			projectionLongitude = MapMath.toRadians(-90);
			minLongitude = MapMath.toRadians(-90);
			maxLongitude = MapMath.toRadians(90);
		}

		override public function project(lplam:Number, lpphi:Number, out:Point):Point
		{
			var cphi:Number, sphi:Number, tphi:Number, t:Number, al:Number, Az:Number,
			z:Number, Av:Number, cdlam:Number, sdlam:Number, r:Number, tag:Boolean;

			cphi = Math.cos(lpphi);
			sphi = Math.sin(lpphi);
			cdlam = Math.cos(sdlam = lamB - lplam);
			sdlam = Math.sin(sdlam);
			if (Math.abs(Math.abs(lpphi) - MapMath.HALFPI) < EPS10) {
				Az = lpphi < 0. ? Math.PI : 0.;
				tphi = Number.MAX_VALUE;
			} else {
				tphi = sphi / cphi;
				Az = Math.atan2(sdlam , C45 * (tphi - cdlam));
			}
			if (tag = (Az > Azba)) {
				cdlam = Math.cos(sdlam = lplam + R110);
				sdlam = Math.sin(sdlam);
				z = S20 * sphi + C20 * cphi * cdlam;
				if (Math.abs(z) > 1.) {
					if (Math.abs(z) > ONEEPS)
					throw new ProjectionError("F");
					else z = z < 0. ? -1. : 1.;
				} else
				z = Math.acos(z);
				if (tphi != Number.MAX_VALUE)
				Az = Math.atan2(sdlam, (C20 * tphi - S20 * cdlam));
				Av = Azab;
				out.y = rhoc;
			} else {
				z = S45 * (sphi + cphi * cdlam);
				if (Math.abs(z) > 1.) {
					if (Math.abs(z) > ONEEPS)
					throw new ProjectionError("F");
					else z = z < 0. ? -1. : 1.;
				} else
				z = Math.acos(z);
				Av = Azba;
				out.y = -rhoc;
			}
			if (z < 0.) throw new ProjectionError("F");
			r = F * (t = Math.pow(Math.tan(.5 * z), n));
			if ((al = .5 * (R104 - z)) < 0.)
			throw new ProjectionError("F");
			al = (t + Math.pow(al, n)) / T;
			if (Math.abs(al) > 1.) {
				if (Math.abs(al) > ONEEPS)
				throw new ProjectionError("F");
				else al = al < 0. ? -1. : 1.;
			} else
			al = Math.acos(al);
			if (Math.abs(t = n * (Av - Az)) < al)
			r /= Math.cos(al + (tag ? t : -t));
			out.x = r * Math.sin(t);
			out.y += (tag ? -r : r) * Math.cos(t);
			if (noskew) {
				t = out.x;
				out.x = -out.x * cAzc - out.y * sAzc;
				out.y = -out.y * cAzc + t * sAzc;
			}
			return out;
		}

		override public function projectInverse(xyx:Number, xyy:Number, out:Point):Point
		{
			var t:Number, r:Number, rp:Number, rl:Number, al:Number, z:Number = 0, fAz:Number,
			Az:Number, s:Number, c:Number, Av:Number, neg:Boolean, i:int;

			if (noskew) {
				t = xyx;
				out.x = -xyx * cAzc + xyy * sAzc;
				out.y = -xyy * cAzc - t * sAzc;
			}
			if (neg = (xyx < 0.)) {
				out.y = rhoc - xyy;
				s = S20;
				c = C20;
				Av = Azab;
			} else {
				out.y += rhoc;
				s = S45;
				c = C45;
				Av = Azba;
			}
			rl = rp = r = MapMath.distance(xyx, xyy);
			fAz = Math.abs(Az = Math.atan2(xyx, xyy));
			for (i = NITER; i > 0; --i) {
				z = 2. * Math.atan(Math.pow(r / F,1 / n));
				al = Math.acos((Math.pow(Math.tan(.5 * z), n) +
				Math.pow(Math.tan(.5 * (R104 - z)), n)) / T);
				if (fAz < al)
				r = rp * Math.cos(al + (neg ? Az : -Az));
				if (Math.abs(rl - r) < EPS)
				break;
				rl = r;
			}
			if (i == 0) throw new ProjectionError("I");
			Az = Av - Az / n;
			out.y = Math.asin(s * Math.cos(z) + c * Math.sin(z) * Math.cos(Az));
			out.x = Math.atan2(Math.sin(Az), c / Math.tan(z) - s * Math.cos(Az));
			if (neg)
			out.x -= R110;
			else
			out.x = lamB - out.x;
			return out;

		}

		override public function hasInverse():Boolean
		{
			return true;
		}

		override public function toString():String
		{
			return "Bipolar Conic";
		}
		
		override public function get shortName():String { return "Bipolar"; }
	}

}

