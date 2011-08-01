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
	
	public class LaskowskiProjection extends Projection
	{
		
		private static const a10:Number =  0.975534;
		private static const a12:Number = -0.119161;
		private static const a32:Number = -0.0143059;
		private static const a14:Number = -0.0547009;
		private static const b01:Number =  1.00384;
		private static const b21:Number =  0.0802894;
		private static const b03:Number =  0.0998909;
		private static const b41:Number =  0.000199025;
		private static const b23:Number = -0.0285500;
		private static const b05:Number = -0.0491032;
		
		override public function project(lplam:Number, lpphi:Number, out:Point):Point 
		{
			var l2:Number, p2:Number;

			l2 = lplam * lplam;
			p2 = lpphi * lpphi;
			out.x = lplam * (a10 + p2 * (a12 + l2 * a32 + p2 * a14));
			out.y = lpphi * (b01 + l2 * (b21 + p2 * b23 + l2 * b41) +
				p2 * (b03 + p2 * b05));
			return out;
		}
		
		override public function toString():String 
		{
			return "Laskowski Tri-Optimal";
		}
		
		override public function get shortName():String { return "Laskowski"; }
		override public function get inventor():String { return "P.H. Laskowski"; }
		override public function get year():int { return 1991; }
		
		
		
	}

}