using UdonSharp;
using UnityEngine;
using VRC.SDKBase;
using VRC.Udon;


/// <summary>
/// A class that inherits <see cref="UdonSharpBehaviour"/>.
/// </summary>
public class <+FILEBASE+> : UdonSharpBehaviour
{
    /// <summary>
    /// This method is called on the frame when a script is enabled just before
    /// any of the Update methods are called the first time.
    /// </summary>
    private void Start()
    {
        <+CURSOR+>
    }

    /// <summary>
    /// This method is called every frame.
    /// </summary>
    private void Update()
    {
    }

    /// <summary>
    /// This method is called every fixed frame-rate frame.
    /// </summary>
    private void FixedUpdate()
    {
    }
}
