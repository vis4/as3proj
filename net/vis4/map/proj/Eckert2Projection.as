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

	public class Eckert2Projection extends Projection
	{
		private static const FXC:Number = 0.46065886596178063902;
		private static const FYC:Number = 1.44720250911653531871;
		private static const C13:Number = 0.33333333333333333333;
		private static const ONEEPS:Number = 1.0000001;
	
		override public function project(lplam:Number, lpphi:Number, out:Point):Point 
		{
			out.x = FXC * lplam * (out.y = Math.sqrt(4. - 3. * Math.sin(Math.abs(lpphi))));
			out.y = FYC * (2. - out.y);
			if ( lpphi < 0.) out.y = -out.y;
			return out;
		}
		
		override public function projectInverse(xyx:Number, xyy:Number, out:Point):Point 
		{
			out.x = xyx / (FXC * ( out.y = 2. - Math.abs(xyy) / FYC) );
			out.y = (4. - out.y * out.y) * C13;
			if (Math.abs(out.y) >= 1.) {
				if (Math.abs(out.y) > ONEEPS) throw new ProjectionError("I");
				else
					out.y = out.y < 0. ? -MapMath.HALFPI : MapMath.HALFPI;
			} else
				out.y = Math.asin(out.y);
			if (xyy < 0)
				out.y = -out.y;
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
			return "Eckert II";
		}
	}

}