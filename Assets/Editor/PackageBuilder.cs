// Editor build script for CI - exports the PremiumAdsMaxAdapter as a .unitypackage

using System.IO;
using UnityEditor;
using UnityEngine;

namespace PremiumAds.Editor
{
    public static class PackageBuilder
    {
        private const string PackagePath = "Assets/PremiumAdsMaxAdapter";
        private const string OutputDir = "dist";
        private const string OutputFile = "dist/PremiumAdsMaxAdapter.unitypackage";

        public static void BuildPackage()
        {
            if (!Directory.Exists(OutputDir))
            {
                Directory.CreateDirectory(OutputDir);
            }

            if (File.Exists(OutputFile))
            {
                File.Delete(OutputFile);
            }

            Debug.Log("[PackageBuilder] Exporting " + PackagePath + " → " + OutputFile);

            AssetDatabase.ExportPackage(
                PackagePath,
                OutputFile,
                ExportPackageOptions.Recurse | ExportPackageOptions.Default
            );

            if (File.Exists(OutputFile))
            {
                long size = new FileInfo(OutputFile).Length;
                Debug.Log("[PackageBuilder] Built: " + OutputFile + " (" + (size / 1024) + " KB)");
            }
            else
            {
                Debug.LogError("[PackageBuilder] Build failed - output file not created");
                EditorApplication.Exit(1);
            }
        }
    }
}
