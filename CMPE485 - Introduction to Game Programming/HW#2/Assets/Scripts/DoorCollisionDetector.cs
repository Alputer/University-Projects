using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class DoorCollisionDetector : MonoBehaviour
{


    public GameObject gameArea;

    public GameObject winningTextContainer;
    
    private Animation doorAnim;

    public AudioSource winningSound;

    void Start(){

        this.doorAnim = transform.gameObject.GetComponent<Animation>();

    }
 private void OnCollisionEnter( Collision collision )
     {
        
         GameObject other = collision.gameObject;
         if (other.transform.name == "Box")
         {
            
            doorAnim.Play("Door_Open");
            AudioManager.instance.TurnOffAudio();
            winningSound.Play();
            StartCoroutine(endGameWinning());
         }
     }

    private IEnumerator endGameWinning(){

        yield return new WaitForSeconds(2f);

        this.winningTextContainer.SetActive(true);

        yield return new WaitForSeconds(2f);

        SceneManager.LoadScene("MenuScene");
}

}
