package shipDock.ui 
{
	/**
	 * ...
	 * @author HongSama
	 */
	public class ProgressMoveBar extends ProgressClippedBar
	{
		
		public function ProgressMoveBar(width:Number, 
										height:Number, 
										progress:String, 
										offsetX:Number = 0, 
										offsetY:Number = 0, 
										border:String = null, 
										bg:String = null,
										onUpdate:Function = null) 
		{
			super(width, height, progress, offsetX, offsetY, border, bg,onUpdate);
			clip.changeClipSize(progressWidth, progressHeight );
			//bar.x = -width;
		}
		
		override protected function update():void 
		{
			//bar.x = -progressWidth * (100 - _percentValue) / 100;
			if (onUpdate != null)
			{
				onUpdate();
			}
		}
	}

}