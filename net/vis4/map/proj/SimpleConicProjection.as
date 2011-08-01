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
	import net.vis4.map.proj.ConicProjection;
	
	public class SimpleConicProjection extends ConicProjection
	{
		private var n:Number;
		private var rho_c:Number;
		private var rho_0:Number;
		private var sig:Number;
		private var c1:Number;
		private var c2:Number;
		private var type:int;

		public static const EULER:int = 0;
		public static const MURD1:int = 1;
		public static const MURD2:int = 2;
		public static const MURD3:int = 3;
		public static const PCONIC:int = 4;
		public static const TISSOT:int = 5;
		public static const VITK1:int = 6;

		public static const EPS10:Number = 1.e-10;
		public static const EPS:Number = 1e-10;
			
		public function SimpleConicProjection(type:int = 0) 
		{
			this.type = type;
			minLatitude = MapMath.toRadians(0);
			maxLatitude = MapMath.toRadians(80);
		}

		
		override public function project(lplam:Number, lpphi:Number, out:Point):Point 
		{
			var rho:Number;
			switch (type) {
				case MURD2:
					rho = rho_c + Math.tan(sig - lpphi);
					break;
				case PCONIC:
					rho = c2 * (c1 - Math.tan(lpphi));
					break;
				default:
					rho = rho_c - lpphi;
					break;
			}
			out.x = rho * Math.sin( lplam *= n );
			out.y = rho_0 - rho * Math.cos(lplam);
			return out;
		}
		
		override public function projectInverse(xyx:Number, xyy:Number, out:Point):Point 
		{
			var rho:Number;
			rho = MapMath.distance(xyx, out.y = rho_0 - xyy);
			if (n < 0.) {
				rho = - rho;
				out.x = - xyx;
				out.y = - xyy;
			}
			out.x = Math.atan2(xyx, xyy) / n;
			switch (type) {
				case PCONIC:
					out.y = Math.atan(c1 - rho / c2) + sig;
					break;
				case MURD2:
					out.y = sig - Math.atan(rho - rho_c);
					break;
				default:
					out.y = rho_c - rho;
			}
			return out;
		}
		
		override public function hasInverse():Boolean 
		{
			return true;
		}
		
		override public function initialize():void 
		{
			super.initialize();
			var del:Number, cs:Number, dummy:Number;
			var p1:Number, p2:Number, d:Number, s:Number;
			var err:int = 0;
					
			p1 = MapMath.toRadians(30);//FIXME
			p2 = MapMath.toRadians(60);//FIXME
			del = 0.5 * (p2 - p1);
			sig = 0.5 * (p2 + p1);
			err = (Math.abs(del) < EPS || Math.abs(sig) < EPS) ? -42 : 0;
			del = del;

			if (err != 0)
				throw new ProjectionError("Error "+err);

			switch (type) {
				case TISSOT:
					n = Math.sin(sig);
					cs = Math.cos(del);
					rho_c = n / cs + cs / n;
					rho_0 = Math.sqrt((rho_c - 2 * Math.sin(projectionLatitude))/n);
					break;
				case MURD1:
					rho_c = Math.sin(del)/(del * Math.tan(sig)) + sig;
					rho_0 = rho_c - projectionLatitude;
					n = Math.sin(sig);
					break;
				case MURD2:
					rho_c = (cs = Math.sqrt(Math.cos(del))) / Math.tan(sig);
					rho_0 = rho_c + Math.tan(sig - projectionLatitude);
					n = Math.sin(sig) * cs;
					break;
				case MURD3:
					rho_c = del / (Math.tan(sig) * Math.tan(del)) + sig;
					rho_0 = rho_c - projectionLatitude;
					n = Math.sin(sig) * Math.sin(del) * Math.tan(del) / (del * del);
					break;
				case EULER:
					n = Math.sin(sig) * Math.sin(del) / del;
					del *= 0.5;
					rho_c = del / (Math.tan(del) * Math.tan(sig)) + sig;	
					rho_0 = rho_c - projectionLatitude;
					break;
				case PCONIC:
					n = Math.sin(sig);
					c2 = Math.cos(del);
					c1 = 1./Math.tan(sig);
					if (Math.abs(del = projectionLatitude - sig) - EPS10 >= MapMath.HALFPI)
						throw new ProjectionError("-43");
					rho_0 = c2 * (c1 - Math.tan(del));
					maxLatitude = MapMath.toRadians(60);//FIXME
					break;
				case VITK1:
					n = (cs = Math.tan(del)) * Math.sin(sig) / del;
					rho_c = del / (cs * Math.tan(sig)) + sig;
					rho_0 = rho_c - projectionLatitude;
					break;
			}
			
		}
		
		override public function isConformal():Boolean 
		{
			return true;
		}
		
		
		override public function toString():String 
		{
			return "Simple Conic";
		}		
	}

}