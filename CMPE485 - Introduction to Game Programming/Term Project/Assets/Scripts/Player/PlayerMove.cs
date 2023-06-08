using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerMove : MonoBehaviour
{

    public float moveSpeed = 10f;
    public float leftRightSpeed = 6.5f;

    public static bool canMove = false;

    public bool isJumping = false;

    public bool comingDown = false;

    public GameObject player;


    void Update()
    {
        transform.Translate(Vector3.forward * moveSpeed * Time.deltaTime, Space.World);
        // Strange bug exists sometimes when player jumps so I solved it naively like this

        if(canMove){
            if(Input.GetKey(KeyCode.A) || Input.GetKey(KeyCode.LeftArrow)){
                if(this.gameObject.transform.position.x > LevelBoundary.leftSide)
                {
                transform.Translate(Vector3.left * leftRightSpeed * Time.deltaTime, Space.World);
                }
            }

            if(Input.GetKey(KeyCode.D) || Input.GetKey(KeyCode.RightArrow)){
                if(this.gameObject.transform.position.x < LevelBoundary.rightSide)
                {
                transform.Translate(Vector3.right * leftRightSpeed * Time.deltaTime, Space.World);
                }
            }

            if(Input.GetKey(KeyCode.Space)){
                if(!isJumping){
                    isJumping = true;
                    player.transform.GetChild(0).GetComponent<Animator>().Play("Jump");
                    StartCoroutine(jumpSequence());
                }
            }

            if(isJumping){
                if(!comingDown)
                    transform.Translate(Vector3.up * Time.deltaTime * 5, Space.World);
                else
                    transform.Translate(Vector3.up * Time.deltaTime * -5, Space.World);
            }
        }
    }

    IEnumerator jumpSequence(){
        yield return new WaitForSeconds(0.5f);
        comingDown = true;
        yield return new WaitForSeconds(0.5f);
        isJumping = false;
        if(player.transform.position.y > 1.6f)
        player.transform.position = new Vector3(player.transform.position.x, 1.5f, player.transform.position.z);
        comingDown = false;
        if(!ObstacleCollision.didCollide)
        player.transform.GetChild(0).GetComponent<Animator>().Play("Standard Run");
        
    }
}
