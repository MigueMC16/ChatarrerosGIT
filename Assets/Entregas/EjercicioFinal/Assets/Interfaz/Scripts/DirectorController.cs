using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Playables;

public class DirectorController : MonoBehaviour
{

    [SerializeField] private PlayableDirector director;

    public void StartDirector()
    {
        director.Play();

    }

    public void StopDirector()
    {
        director.Stop();
    }

}
