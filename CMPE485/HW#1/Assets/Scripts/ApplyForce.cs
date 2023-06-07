using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ApplyForce : MonoBehaviour
{

    public Rigidbody rigidBody;
    public Vector3 force;
    // Start is called before the first frame update
    void Start()
    {
        this.rigidBody = GetComponent<Rigidbody>();
        this.force = new Vector3(0.1f, 0, 0.1f);
    }

    // Update is called once per frame
    void Update()
    {

        this.rigidBody.AddForce(force, ForceMode.VelocityChange);
    }
}
