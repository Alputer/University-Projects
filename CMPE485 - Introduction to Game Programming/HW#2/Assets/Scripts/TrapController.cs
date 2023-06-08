using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TrapController : MonoBehaviour
{
    public GameObject trap;
    void Start()
    {
        StartCoroutine(TrapMover());
    }

    // Update is called once per frame
    private IEnumerator TrapMover(){
        while(true){

        for(int i=0;i<=27;i++){

        trap.transform.position = new Vector3(14.5f + i * 0.1f, 0f, 10f);
        yield return new WaitForSeconds(0.1f);
        }

        for(int i=0;i<=27;i++){

        trap.transform.position = new Vector3(17.2f - i * 0.1f, 0f, 10f);
        yield return new WaitForSeconds(0.1f);
        }

        }
    }
}
