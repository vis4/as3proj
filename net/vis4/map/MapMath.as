package net.vis4.map 
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import net.vis4.map.proj.ProjectionError;
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
	
	Ported to ActionScript by Gregor Aisch (vis4.net)
	
	*/
	public class MapMath
	{
		
		public static const HALFPI:Number = Math.PI/2.0;
		public static const QUARTERPI:Number = Math.PI/4.0;
		public static const TWOPI:Number = Math.PI*2.0;
		public static const RTD:Number = 180.0/Math.PI;
		public static const DTR:Number = Math.PI/180.0;
		public static const WORLD_BOUNDS_RAD:Rectangle = new Rectangle(-Math.PI, -Math.PI/2, Math.PI*2, Math.PI);
		public static const WORLD_BOUNDS:Rectangle = new Rectangle(-180, -90, 360, 180);

		/**
		 * Degree versions of trigonometric functions
		 */
		public static function sind(v:Number):Number {
			return Math.sin(v * DTR);
		}
		
		public static function cosd(v:Number):Number {
			return Math.cos(v * DTR);
		}
		
		public static function tand(v:Number):Number {
			return Math.tan(v * DTR);
		}
		
		public static function asind(v:Number):Number {
			return Math.asin(v) * RTD;
		}
		
		public static function acosd(v:Number):Number {
			return Math.acos(v) * RTD;
		}
		
		public static function atand(v:Number):Number {
			return Math.atan(v) * RTD;
		}
		
		public static function atan2d(y:Number, x:Number):Number {
			return Math.atan2(y, x) * RTD;
		}
		
		public static function asin(v:Number):Number {
			if (Math.abs(v) > 1.)
				return v < 0.0 ? -Math.PI/2 : Math.PI/2;
			return Math.asin(v);
		}

		public static function acos(v:Number):Number {
			if (Math.abs(v) > 1.)
				return v < 0.0 ? Math.PI : 0.0;
			return Math.acos(v);
		}

		public static function sqrt(v:Number):Number {
			return v < 0.0 ? 0.0 : Math.sqrt(v);
		}
		
		public static function distance(dx:Number, dy:Number):Number {
			return Math.sqrt(dx*dx+dy*dy);
		}

		public static function distancePoint(a:Point, b:Point):Number {
			return distance(a.x-b.x, a.y-b.y);
		}

		public static function hypot(x:Number, y:Number):Number {
			if (x < 0.0)
				x = -x;
			else if (x == 0.0)
				return y < 0.0 ? -y : y;
			if (y < 0.0)
				y = -y;
			else if (y == 0.0)
				return x;
			if (x < y) {
				x /= y;
				return y * Math.sqrt(1.0 + x * x);
			} else {
				y /= x;
				return x * Math.sqrt(1.0 + y * y);
			}
		}

		public static function atan2(y:Number, x:Number):Number {
			return Math.atan2(y, x);
		}

		public static function trunc(v:Number):Number {
			return v < 0.0 ? Math.ceil(v) : Math.floor(v);
		}
		
		public static function frac(v:Number):Number {
			return v - trunc(v);
		}
		
		public static function degToRad(v:Number):Number {
			return v * Math.PI / 180.0;
		}

		public static function radToDeg(v:Number):Number {
			return v * 180.0 / Math.PI;
		}

		// For negative angles, d should be negative, m & s positive.
		public static function dmsToRad(d:Number, m:Number, s:Number):Number {
			if (d >= 0)
				return (d + m/60 + s/3600) * Math.PI / 180.0;
			return (d - m/60 - s/3600) * Math.PI / 180.0;
		}

		// For negative angles, d should be negative, m & s positive.
		public static function dmsToDeg(d:Number, m:Number, s:Number):Number {
			if (d >= 0)
				return (d + m/60 + s/3600);
			return (d - m/60 - s/3600);
		}

		public static function normalizeLatitude(angle:Number):Number {
			if (!isFinite(angle) || isNaN(angle))
				throw new ProjectionError("Infinite latitude");
			while (angle > MapMath.HALFPI)
				angle -= Math.PI;
			while (angle < -MapMath.HALFPI)
				angle += Math.PI;
			return angle;
	//		return Math.IEEEremainder(angle, Math.PI);
		}
		
		public static function normalizeLongitude(angle:Number):Number {
			if (!isFinite(angle) || isNaN(angle))
				throw new ProjectionError("Infinite longitude");
			while (angle > Math.PI)
				angle -= TWOPI;
			while (angle < -Math.PI)
				angle += TWOPI;
			return angle;
	//		return Math.IEEEremainder(angle, Math.PI);
		}
		
		public static function normalizeAngle(angle:Number):Number {
			if (!isFinite(angle) || isNaN(angle))
				throw new ProjectionError("Infinite angle");
			while (angle > TWOPI)
				angle -= TWOPI;
			while (angle < 0)
				angle += TWOPI;
			return angle;
		}
		
	/*
		public static void latLongToXYZ(Point ll, Point3D xyz) {
			double c = Math.cos(ll.y);
			xyz.x = c * Math.cos(ll.x);
			xyz.y = c * Math.sin(ll.x);
			xyz.z = Math.sin(ll.y);
		}

		public static void xyzToLatLong(Point3D xyz, Point ll) {
			ll.y = MapMath.asin(xyz.z);
			ll.x = MapMath.atan2(xyz.y, xyz.x);
		}
	*/

		public static function greatCircleDistance(lon1:Number, lat1:Number, lon2:Number, lat2:Number):Number {
			var dlat:Number = Math.sin((lat2-lat1)/2);
			var dlon:Number = Math.sin((lon2-lon1)/2);
			var r:Number = Math.sqrt(dlat*dlat + Math.cos(lat1)*Math.cos(lat2)*dlon*dlon);
			return 2.0 * Math.asin(r);
		}

		public static function sphericalAzimuth(lat0:Number, lon0:Number, lat:Number, lon:Number):Number {
			var diff:Number = lon - lon0;
			var coslat:Number = Math.cos(lat);

			return Math.atan2(
				coslat * Math.sin(diff),
				(Math.cos(lat0) * Math.sin(lat) -
				Math.sin(lat0) * coslat * Math.cos(diff))
			);
		}

		public static function sameSigns(a:Number, b:Number):Boolean {
			return a < 0 == b < 0;
		}

		public static function sameSignsInt(a:int, b:int):Boolean {
			return a < 0 == b < 0;
		}		
		
		public static function takeSign(a:Number, b:Number):Number {
			a = Math.abs(a);
			if (b < 0)
				return -a;
			return a;
		}

		public static function takeSignInt(a:int , b:int):int {
			a = Math.abs(a);
			if (b < 0)
				return -a;
			return a;
		}

		public static const DONT_INTERSECT:int = 0;
		public static const DO_INTERSECT:int = 1;
		public static const COLLINEAR:int = 2;

		public static function intersectSegments(aStart:Point, aEnd:Point, bStart:Point, bEnd:Point, p:Point):int{
			var a1:Number, a2:Number, b1:Number, b2:Number, c1:Number, c2:Number;
			var r1:Number, r2:Number, r3:Number, r4:Number;
			var denom:Number, offset:Number, num:Number;

			a1 = aEnd.y-aStart.y;
			b1 = aStart.x-aEnd.x;
			c1 = aEnd.x*aStart.y - aStart.x*aEnd.y;
			r3 = a1*bStart.x + b1*bStart.y + c1;
			r4 = a1*bEnd.x + b1*bEnd.y + c1;

			if (r3 != 0 && r4 != 0 && sameSigns(r3, r4))
				return DONT_INTERSECT;

			a2 = bEnd.y-bStart.y;
			b2 = bStart.x-bEnd.x;
			c2 = bEnd.x*bStart.y-bStart.x*bEnd.y;
			r1 = a2*aStart.x + b2*aStart.y + c2;
			r2 = a2*aEnd.x + b2*aEnd.y + c2;

			if (r1 != 0 && r2 != 0 && sameSigns(r1, r2))
				return DONT_INTERSECT;

			denom = a1*b2 - a2*b1;
			if (denom == 0)
				return COLLINEAR;

			offset = denom < 0 ? -denom/2 : denom/2;

			num = b1*c2 - b2*c1;
			p.x = (num < 0 ? num-offset : num+offset) / denom;

			num = a2*c1 - a1*c2;
			p.y = (num < 0 ? num-offset : num+offset) / denom;

			return DO_INTERSECT;
		}

		public static function dot(a:Point, b:Point):Number {
			return a.x*b.x + a.y*b.y;
		}
		
		public static function perpendicular(a:Point):Point {
			return new Point(-a.y, a.x);
		}
		
		public static function add(a:Point, b:Point):Point {
			return new Point(a.x+b.x, a.y+b.y);
		}
		
		public static function subtract(a:Point, b:Point):Point {
			return new Point(a.x-b.x, a.y-b.y);
		}
		
		public static function multiply(a:Point, b:Point):Point {
			return new Point(a.x*b.x, a.y*b.y);
		}
		
		public static function crossPoint(a:Point, b:Point):Number {
			return a.x*b.y - b.x*a.y;
		}

		public static function cross(x1:Number, y1:Number, x2:Number, y2:Number):Number {
			return x1*y2 - x2*y1;
		}

		public static function normalize(a:Point):void {
			var d:Number = distance(a.x, a.y);
			a.x /= d;
			a.y /= d;
		}
		
		public static function negate(a:Point):void {
			a.x = -a.x;
			a.y = -a.y;
		}
		
		public static function longitudeDistance(l1:Number, l2:Number):Number {
			return Math.min(
				Math.abs(l1-l2), 
				((l1 < 0) ? l1+Math.PI : Math.PI-l1) + ((l2 < 0) ? l2+Math.PI : Math.PI-l2)
			);
		}

		public static function geocentricLatitude(lat:Number, flatness:Number):Number {
			var f:Number = 1.0 - flatness;
			return Math.atan((f*f) * Math.tan(lat));
		}

		public static function geographicLatitude(lat:Number, flatness:Number):Number {
			var f:Number = 1.0 - flatness;
			return Math.atan(Math.tan(lat) / (f*f));
		}

		public static function tsfn(phi:Number, sinphi:Number, e:Number):Number {
			sinphi *= e;
			return (Math.tan (.5 * (MapMath.HALFPI - phi)) /
			   Math.pow((1. - sinphi) / (1. + sinphi), .5 * e));
		}

		public static function msfn(sinphi:Number, cosphi:Number, es:Number):Number {
			return cosphi / Math.sqrt(1.0 - es * sinphi * sinphi);
		}

		private static const N_ITER:int = 15;

		public static function phi2(ts:Number, e:Number):Number {
			var eccnth:Number, phi:Number, con:Number, dphi:Number;
			var i:int;

			eccnth = .5 * e;
			phi = MapMath.HALFPI - 2. * Math.atan(ts);
			i = N_ITER;
			do {
				con = e * Math.sin(phi);
				dphi = MapMath.HALFPI - 2. * Math.atan(ts * Math.pow((1. - con) / (1. + con), eccnth)) - phi;
				phi += dphi;
			} while (Math.abs(dphi) > 1e-10 && --i != 0);
			if (i <= 0)
				throw new ProjectionError();
			return phi;
		}

		private static const C00:Number = 1.0;
		private static const C02:Number = .25;
		private static const C04:Number = .046875;
		private static const C06:Number = .01953125;
		private static const C08:Number = .01068115234375;
		private static const C22:Number = .75;
		private static const C44:Number = .46875;
		private static const C46:Number = .01302083333333333333;
		private static const C48:Number = .00712076822916666666;
		private static const C66:Number = .36458333333333333333;
		private static const C68:Number = .00569661458333333333;
		private static const C88:Number = .3076171875;
		private static const MAX_ITER:int = 10;

		public static function enfn(es:Number):Array {
			var t:Number;
			var en:Array = [0, 0, 0, 0, 0];
			en[0] = C00 - es * (C02 + es * (C04 + es * (C06 + es * C08)));
			en[1] = es * (C22 - es * (C04 + es * (C06 + es * C08)));
			en[2] = (t = es * es) * (C44 - es * (C46 + es * C48));
			en[3] = (t *= es) * (C66 - es * C68);
			en[4] = t * es * C88;
			return en;
		}

		public static function mlfn(phi:Number, sphi:Number, cphi:Number, en:Array):Number {
			cphi *= sphi;
			sphi *= sphi;
			return en[0] * phi - cphi * (en[1] + sphi*(en[2] + sphi*(en[3] + sphi*en[4])));
		}

		public static function inv_mlfn(arg:Number, es:Number, en:Array):Number {
			var s:Number, t:Number, phi:Number, k:Number = 1./(1.-es);

			phi = arg;
			for (var i:int = MAX_ITER; i != 0; i--) {
				s = Math.sin(phi);
				t = 1. - es * s * s;
				phi -= t = (mlfn(phi, s, Math.cos(phi), en) - arg) * (t * Math.sqrt(t)) * k;
				if (Math.abs(t) < 1e-11)
					return phi;
			}
			return phi;
		}

		private static const P00:Number = .33333333333333333333;
		private static const P01:Number = .17222222222222222222;
		private static const P02:Number = .10257936507936507936;
		private static const P10:Number = .06388888888888888888;
		private static const P11:Number = .06640211640211640211;
		private static const P20:Number = .01641501294219154443;

		public static function authset(es:Number):Array {
			var t:Number;
			var APA:Array = [0,0,0];
			APA[0] = es * P00;
			t = es * es;
			APA[0] += t * P01;
			APA[1] = t * P10;
			t *= es;
			APA[0] += t * P02;
			APA[1] += t * P11;
			APA[2] = t * P20;
			return APA;
		}

		public static function authlat(beta:Number, APA:Array):Number {
			var t:Number = beta+beta;
			return(beta + APA[0] * Math.sin(t) + APA[1] * Math.sin(t+t) + APA[2] * Math.sin(t+t+t));
		}
		
		public static function qsfn(sinphi:Number, e:Number, one_es:Number):Number {
			var con:Number;

			if (e >= 1.0e-7) {
				con = e * sinphi;
				return (one_es * (sinphi / (1. - con * con) -
				   (.5 / e) * Math.log ((1. - con) / (1. + con))));
			} else
				return (sinphi + sinphi);
		}

		/*
		 * Java translation of "Nice Numbers for Graph Labels"
		 * by Paul Heckbert
		 * from "Graphics Gems", Academic Press, 1990
		 */
		public static function niceNumber(x:Number, round:Boolean):Number {
			var expv:int;				/* exponent of x */
			var f:Number;				/* fractional part of x */
			var nf:Number;				/* nice, rounded fraction */

			expv = Math.floor(Math.log(x) / Math.log(10));
			f = x/Math.pow(10., expv);		/* between 1 and 10 */
			if (round) {
				if (f < 1.5)
					nf = 1.;
				else if (f < 3.)
					nf = 2.;
				else if (f < 7.)
					nf = 5.;
				else
					nf = 10.;
			} else if (f <= 1.)
				nf = 1.;
			else if (f <= 2.)
				nf = 2.;
			else if (f <= 5.)
				nf = 5.;
			else
				nf = 10.;
			return nf*Math.pow(10., expv);
		}
		
		public static function toRadians(d:Number):Number
		{
			return degToRad(d);
		}
		
		public static function toDegrees(r:Number):Number
		{
			return radToDeg(r);
		}

	}

}