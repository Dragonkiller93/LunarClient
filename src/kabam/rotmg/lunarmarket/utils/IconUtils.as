package kabam.rotmg.lunarmarket.utils
{
import com.company.assembleegameclient.objects.ObjectLibrary;
import com.company.assembleegameclient.util.TextureRedrawer;
import com.company.util.AssetLibrary;

import flash.display.BitmapData;

public class IconUtils
{
    /* Draw the fame icon */
    public static function getFameIcon(size:int = 40) : BitmapData
    {
        var fameBD:BitmapData = AssetLibrary.getImageFromSet("lofiObj3",224);
        return TextureRedrawer.redraw(fameBD,size,true,0);
    }

    /* Draw the gold icon */
    public static function getCoinIcon(size:int = 40) : BitmapData {
        var fameBD:BitmapData = AssetLibrary.getImageFromSet("LunarGold", 0);
        fameBD = ObjectLibrary.shrinkToFit(fameBD, 50, true, 0);
        return fameBD;
    }
}
}