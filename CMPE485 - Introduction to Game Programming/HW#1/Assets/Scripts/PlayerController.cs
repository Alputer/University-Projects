using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerController : MonoBehaviour
{

    //Rigid body has some flaws, thus using CharacterController is better (Not sure)
    public float speed;
    //public Rigidbody rigidBody;
    public float jumpForce;
    public CharacterController controller;

    public float gravityScale;

    private Vector3 moveDirection;
    
    // Start is called before the first frame update
    void Start()
    {
        this.speed = 10;
        this.jumpForce = 50;
        this.controller = GetComponent<CharacterController>();
        this.gravityScale = 0.2f;
        
        //this.rigidBody = GetComponent<Rigidbody>();   
    }

    // Update is called once per frame
    void Update()
    {
        /*
        rigidBody.velocity = new Vector3(Input.GetAxis("Horizontal") * speed, rigidBody.velocity.y, Input.GetAxis("Vertical") * speed);
        if(Input.GetButtonDown("Jump")){ // If space key is pressed
            rigidBody.velocity = new Vector3(rigidBody.velocity.x, jumpForce, rigidBody.velocity.z);
        */
        this.moveDirection = new Vector3(Input.GetAxis("Horizontal") * speed, moveDirection.y , Input.GetAxis("Vertical") * speed);

        if(controller.isGrounded){
            this.moveDirection.y = 0f;
            if(Input.GetButtonDown("Jump")){ // If space key is pressed
                this.moveDirection.y = jumpForce;
            }
        }
        
        this.moveDirection.y += Physics.gravity.y * gravityScale;
        controller.Move(moveDirection * Time.deltaTime); //40fps => deltaTime = 1/40 second
    } 
}

