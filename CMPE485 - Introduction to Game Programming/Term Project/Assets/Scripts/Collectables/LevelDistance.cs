using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;
public class LevelDistance : MonoBehaviour
{

    public TMP_Text distanceRunText;

    public TMP_Text distanceRunLevelEndText;
    public int distanceRun;
    public bool addingDistance = false;

    public float displayDelay = 0.35f;
  

    // Update is called once per frame
    void Update()
    {
        if(!addingDistance){
            addingDistance = true;
            StartCoroutine(AddingDistance());
        }
    }

    IEnumerator AddingDistance(){

        distanceRun += 1;
        this.distanceRunText.SetText("" + distanceRun);
        this.distanceRunLevelEndText.SetText("" + distanceRun);
        yield return new WaitForSeconds(displayDelay);
        addingDistance = false;

    }
}
