using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class PlayerController : MonoBehaviour
{

    
    public float speed;
    
    public float jumpForce;
    public CharacterController controller;

    public GameObject losingTextContainer;

    public float gravityScale;

    [SerializeField]
    private float pushForce;

    private Vector3 moveDirection;

     public AudioSource losingSound;
    
    // Start is called before the first frame update
    void Start()
    {
        this.controller = GetComponent<CharacterController>();
    }

    // Update is called once per frame
    void Update()
    {

    
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

     private void OnCollisionEnter( Collision collision )
     {
        
         GameObject other = collision.gameObject;
         if (other.transform.name == "Trap")
         {
            this.losingSound.Play();
            AudioManager.instance.TurnOffAudio();
            StartCoroutine(endGameLosing());
         }
     }

    private void OnControllerColliderHit(ControllerColliderHit hit){

         Rigidbody body = hit.collider.attachedRigidbody;

        if (body == null || body.isKinematic)
            return;

         Vector3 pushDir = new Vector3(hit.moveDirection.x, 0, hit.moveDirection.z);

         body.velocity = pushDir * pushForce;
    } 

    private IEnumerator endGameLosing(){

        yield return new WaitForSeconds(1f);

        this.losingTextContainer.SetActive(true);

        yield return new WaitForSeconds(2f);

        SceneManager.LoadScene("MenuScene"); 

    }
}

