package kabam.rotmg.lunarmarket.utils {
import com.company.assembleegameclient.objects.ObjectLibrary;

public class ItemUtils
{
    /* Add restricted values to this */
    public static function isBanned(itemType:int) : Boolean
    {
        return ObjectLibrary.isSoulbound(itemType)
    }
}
}
