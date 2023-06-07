using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LevelBoundary : MonoBehaviour
{

    public static float leftSide  = -3.5f;
    public static float rightSide = 3.5f;
    public float internalRight;
    public float internalLeft;
    // Start is called before the first frame update
    void Start()
    {
     internalLeft = leftSide;
     internalRight = rightSide;   
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
