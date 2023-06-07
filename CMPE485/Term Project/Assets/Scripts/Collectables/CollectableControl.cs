using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;
using UnityEngine.UI;

public class CollectableControl : MonoBehaviour
{
    public static int coinCount = 0;
    public TMP_Text coinCountText;

    public TMP_Text coinCountLevelEndText;

    // Update is called once per frame
    void Update()
    {
        this.coinCountText.SetText("" + coinCount);
        this.coinCountLevelEndText.SetText("" + coinCount);
    }

}
