using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraController : MonoBehaviour
{

    public PlayerController target; // Set in the unity inspector
    
    public float rotateSpeed;

    public Vector3 offset; // Allows us to follow the player

    // Start is called before the first frame update
    void Start()
    {
        
        this.offset = this.target.transform.position - this.transform.position;
    }

    // Update is called once per frame
    void LateUpdate()
    {
        this.transform.position = this.target.transform.position - this.offset; // Follow the player
        this.transform.LookAt(this.target.transform); // Adjusts the angle
        
    }
}
