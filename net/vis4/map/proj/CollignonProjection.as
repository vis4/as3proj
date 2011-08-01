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

	public class CollignonProjection extends Projection
	{
		private static const FXC:Number = 1.12837916709551257390;
		private static const FYC:Number = 1.77245385090551602729;
		private static const ONEEPS:Number = 1.0000001;
	
		override public function project(lplam:Number, lpphi:Number, out:Point):Point 
		{
			if ((out.y = 1. - Math.sin(lpphi)) <= 0.)
				out.y = 0.;
			else
				out.y = Math.sqrt(out.y);
			out.x = FXC * lplam * out.y;
			out.y = FYC * (1. - out.y);
			return out;
		}
		
		override public function projectInverse(xyx:Number, xyy:Number, out:Point):Point 
		{
			var lpphi:Number = xyy / FYC - 1.;
			if (Math.abs(out.y = 1. - lpphi * lpphi) < 1.)
				out.y = Math.asin(lpphi);
			else if (Math.abs(lpphi) > ONEEPS) throw new ProjectionError("I");
			else	out.y = lpphi < 0. ? -MapMath.HALFPI : MapMath.HALFPI;
			if ((out.x = 1. - Math.sin(lpphi)) <= 0.)
				out.x = 0.;
			else
				out.x = xyx / (FXC * Math.sqrt(out.x));
			out.y = lpphi;
			return out;
		}
		
		override public function isEqualArea():Boolean 
		{
			return true;
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
			return "Collignon";
		}
		
	}

}