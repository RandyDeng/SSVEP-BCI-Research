using System;

namespace SSVEP_Summer_Project
{
#if WINDOWS || XBOX
    static class Program
    {
        /// <summary>
        /// The main entry point for the application.
        /// </summary>
        static void Main(string[] args)
        {
            using (SSVEPmain ssvep = new SSVEPmain())
            {
                ssvep.Run();
            }
        }
    }
#endif
}

