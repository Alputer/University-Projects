using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SpawnIceObject : MonoBehaviour
{

    public GameObject icePrefab;
    // Start is called before the first frame update
    public float timeLeft, originalTime;
    void Start()
    {
        this.timeLeft = 0;
        this.originalTime = Time.deltaTime * 1000f;
    }

    // Update is called once per frame
    void Update()
    {
        this.timeLeft -= Time.deltaTime;
    
        if(Input.GetButtonDown("Fire1") && this.timeLeft <= 0){
            {
    Vector3 randomPosition = new Vector3(
        Random.Range(-9, 9),
        Random.Range(2, 6),
        Random.Range(-9, 9)
    );
        Instantiate(icePrefab, randomPosition, Quaternion.identity);
        this.timeLeft = this.originalTime;
}
        }
    }
}
