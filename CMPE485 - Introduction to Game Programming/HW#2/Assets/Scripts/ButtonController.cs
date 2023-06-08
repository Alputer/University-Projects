using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class ButtonController : MonoBehaviour
{
    // Start is called before the first frame update
    public void PlayTheRound(){

        SceneManager.LoadScene("GameScene");

    }

    // Update is called once per frame
    public void QuitApplication()
    {

        Application.Quit();

    }
}
