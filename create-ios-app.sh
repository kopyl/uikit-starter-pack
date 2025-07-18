#!/bin/bash

# Check if project name argument is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <project-name>"
    echo "Example: $0 my-awesome-app"
    exit 1
fi

APP_NAME="$1"

# Auto-detect development team ID from keychain
DEVELOPMENT_TEAM=$(security find-identity -v -p codesigning | grep "Developer ID Application" | grep -o '([A-Z0-9]\{10\})' | tr -d '()' | head -1)
if [ -z "$DEVELOPMENT_TEAM" ]; then
    # Fallback to first available code signing identity
    DEVELOPMENT_TEAM=$(security find-identity -v -p codesigning | grep -o '([A-Z0-9]\{10\})' | head -1 | tr -d '()')
fi

if [ -z "$DEVELOPMENT_TEAM" ]; then
    echo "Warning: No development team found. You may need to set DEVELOPMENT_TEAM manually in Xcode."
    DEVELOPMENT_TEAM=""
else
    echo "Using development team: $DEVELOPMENT_TEAM"
fi

ORG_IDENTIFIER=$(defaults read kopyl.uikit-starter-pack organization-identifier 2>/dev/null || echo "")

if [ -z "$ORG_IDENTIFIER" ]; then
  echo "Organization identifier not found in user defaults."
  echo -n "Enter your organization identifier (e.g., com.yourcompany, yourname): "
  read ORG_IDENTIFIER
  
  if [ -z "$ORG_IDENTIFIER" ]; then
    echo "Error: Organization identifier cannot be empty"
    exit 1
  fi
  
  # Save to user defaults
  defaults write kopyl.uikit-starter-pack organization-identifier "$ORG_IDENTIFIER"
  echo "Organization identifier '$ORG_IDENTIFIER' saved to user defaults."
else
  echo "Using saved organization identifier: $ORG_IDENTIFIER"
fi

SANITIZED_NAME=$(echo "$APP_NAME" | sed -E 's/[^a-zA-Z0-9]+/-/g')
BUNDLE_ID_NAME=$(echo "$SANITIZED_NAME" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9-]//g')

# Create main project directory
mkdir -p "$SANITIZED_NAME"

# Create Xcode project structure
mkdir -p "$SANITIZED_NAME/$SANITIZED_NAME.xcodeproj"
mkdir -p "$SANITIZED_NAME/$SANITIZED_NAME.xcodeproj/project.xcworkspace"
mkdir -p "$SANITIZED_NAME/$SANITIZED_NAME.xcodeproj/project.xcworkspace/xcshareddata/swiftpm/configuration"
mkdir -p "$SANITIZED_NAME/$SANITIZED_NAME.xcodeproj/xcshareddata/xcschemes"

# Create app source structure
mkdir -p "$SANITIZED_NAME/$SANITIZED_NAME"
mkdir -p "$SANITIZED_NAME/$SANITIZED_NAME/Assets.xcassets/AccentColor.colorset"
mkdir -p "$SANITIZED_NAME/$SANITIZED_NAME/Assets.xcassets/AppBackground.colorset"
mkdir -p "$SANITIZED_NAME/$SANITIZED_NAME/Assets.xcassets/AppIcon.appiconset"
mkdir -p "$SANITIZED_NAME/$SANITIZED_NAME/Base.lproj"
mkdir -p "$SANITIZED_NAME/$SANITIZED_NAME/Views/Base.lproj"

# Create project.pbxproj
cat > "$SANITIZED_NAME/$SANITIZED_NAME.xcodeproj/project.pbxproj" << EOF
{
	archiveVersion = 1;
	classes = {
	};
	objectVersion = 56;
	objects = {

/* Begin PBXBuildFile section */
		A11EDACE2C4791F2002C79B6 /* AppDelegate.swift in Sources */ = {isa = PBXBuildFile; fileRef = A11EDACD2C4791F2002C79B6 /* AppDelegate.swift */; };
		A11EDAD02C4791F2002C79B6 /* SceneDelegate.swift in Sources */ = {isa = PBXBuildFile; fileRef = A11EDACF2C4791F2002C79B6 /* SceneDelegate.swift */; };
		A11EDAD72C4791F4002C79B6 /* Assets.xcassets in Resources */ = {isa = PBXBuildFile; fileRef = A11EDAD62C4791F4002C79B6 /* Assets.xcassets */; };
		A11EDADA2C4791F4002C79B6 /* Base in Resources */ = {isa = PBXBuildFile; fileRef = A11EDAD92C4791F4002C79B6 /* Base */; };
		A14AC1862C4796B6003AA6B9 /* MainView.swift in Sources */ = {isa = PBXBuildFile; fileRef = A14AC1852C4796B6003AA6B9 /* MainView.swift */; };
/* End PBXBuildFile section */

/* Begin PBXFileReference section */
		A11EDACA2C4791F2002C79B6 /* SANITIZED_NAME.app */ = {isa = PBXFileReference; explicitFileType = wrapper.application; includeInIndex = 0; path = "SANITIZED_NAME.app"; sourceTree = BUILT_PRODUCTS_DIR; };
		A11EDACD2C4791F2002C79B6 /* AppDelegate.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = AppDelegate.swift; sourceTree = "<group>"; };
		A11EDACF2C4791F2002C79B6 /* SceneDelegate.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = SceneDelegate.swift; sourceTree = "<group>"; };
		A11EDAD62C4791F4002C79B6 /* Assets.xcassets */ = {isa = PBXFileReference; lastKnownFileType = folder.assetcatalog; path = Assets.xcassets; sourceTree = "<group>"; };
		A11EDAD92C4791F4002C79B6 /* Base */ = {isa = PBXFileReference; lastKnownFileType = file.storyboard; name = Base; path = Base.lproj/LaunchScreen.storyboard; sourceTree = "<group>"; };
		A11EDADB2C4791F4002C79B6 /* Info.plist */ = {isa = PBXFileReference; lastKnownFileType = text.plist.xml; path = Info.plist; sourceTree = "<group>"; };
		A14AC1852C4796B6003AA6B9 /* MainView.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = MainView.swift; sourceTree = "<group>"; };
/* End PBXFileReference section */

/* Begin PBXFrameworksBuildPhase section */
		A11EDAC72C4791F2002C79B6 /* Frameworks */ = {
			isa = PBXFrameworksBuildPhase;
			buildActionMask = 2147483647;
			files = (
			);
			runOnlyForDeploymentPostprocessing = 0;
		};
/* End PBXFrameworksBuildPhase section */

/* Begin PBXGroup section */
		A11EDAC12C4791F2002C79B6 = {
			isa = PBXGroup;
			children = (
				A11EDACC2C4791F2002C79B6 /* SANITIZED_NAME */,
				A11EDACB2C4791F2002C79B6 /* Products */,
			);
			sourceTree = "<group>";
		};
		A11EDACB2C4791F2002C79B6 /* Products */ = {
			isa = PBXGroup;
			children = (
				A11EDACA2C4791F2002C79B6 /* SANITIZED_NAME.app */,
			);
			name = Products;
			sourceTree = "<group>";
		};
		A11EDACC2C4791F2002C79B6 /* SANITIZED_NAME */ = {
			isa = PBXGroup;
			children = (
				A14AC1842C4796A9003AA6B9 /* Views */,
				A11EDACD2C4791F2002C79B6 /* AppDelegate.swift */,
				A11EDACF2C4791F2002C79B6 /* SceneDelegate.swift */,
				A11EDAD62C4791F4002C79B6 /* Assets.xcassets */,
				A11EDAD82C4791F4002C79B6 /* LaunchScreen.storyboard */,
				A11EDADB2C4791F4002C79B6 /* Info.plist */,
			);
			path = "SANITIZED_NAME";
			sourceTree = "<group>";
		};
		A14AC1842C4796A9003AA6B9 /* Views */ = {
			isa = PBXGroup;
			children = (
				A14AC1852C4796B6003AA6B9 /* MainView.swift */,
			);
			path = Views;
			sourceTree = "<group>";
		};
/* End PBXGroup section */

/* Begin PBXNativeTarget section */
		A11EDAC92C4791F2002C79B6 /* SANITIZED_NAME */ = {
			isa = PBXNativeTarget;
			buildConfigurationList = A11EDADE2C4791F4002C79B6 /* Build configuration list for PBXNativeTarget "SANITIZED_NAME" */;
			buildPhases = (
				A11EDAC62C4791F2002C79B6 /* Sources */,
				A11EDAC72C4791F2002C79B6 /* Frameworks */,
				A11EDAC82C4791F2002C79B6 /* Resources */,
			);
			buildRules = (
			);
			dependencies = (
			);
			name = "SANITIZED_NAME";
			productName = "SANITIZED_NAME";
			productReference = A11EDACA2C4791F2002C79B6 /* SANITIZED_NAME.app */;
			productType = "com.apple.product-type.application";
		};
/* End PBXNativeTarget section */

/* Begin PBXProject section */
		A11EDAC22C4791F2002C79B6 /* Project object */ = {
			isa = PBXProject;
			attributes = {
				BuildIndependentTargetsInParallel = 1;
				LastSwiftUpdateCheck = 1540;
				LastUpgradeCheck = 1540;
				TargetAttributes = {
					A11EDAC92C4791F2002C79B6 = {
						CreatedOnToolsVersion = 15.4;
					};
				};
			};
			buildConfigurationList = A11EDAC52C4791F2002C79B6 /* Build configuration list for PBXProject "SANITIZED_NAME" */;
			compatibilityVersion = "Xcode 14.0";
			developmentRegion = en;
			hasScannedForEncodings = 0;
			knownRegions = (
				en,
				Base,
			);
			mainGroup = A11EDAC12C4791F2002C79B6;
			productRefGroup = A11EDACB2C4791F2002C79B6 /* Products */;
			projectDirPath = "";
			projectRoot = "";
			targets = (
				A11EDAC92C4791F2002C79B6 /* SANITIZED_NAME */,
			);
		};
/* End PBXProject section */

/* Begin PBXResourcesBuildPhase section */
		A11EDAC82C4791F2002C79B6 /* Resources */ = {
			isa = PBXResourcesBuildPhase;
			buildActionMask = 2147483647;
			files = (
				A11EDAD72C4791F4002C79B6 /* Assets.xcassets in Resources */,
				A11EDADA2C4791F4002C79B6 /* Base in Resources */,
			);
			runOnlyForDeploymentPostprocessing = 0;
		};
/* End PBXResourcesBuildPhase section */

/* Begin PBXSourcesBuildPhase section */
		A11EDAC62C4791F2002C79B6 /* Sources */ = {
			isa = PBXSourcesBuildPhase;
			buildActionMask = 2147483647;
			files = (
				A11EDAD02C4791F2002C79B6 /* SceneDelegate.swift in Sources */,
				A14AC1862C4796B6003AA6B9 /* MainView.swift in Sources */,
				A11EDACE2C4791F2002C79B6 /* AppDelegate.swift in Sources */,
			);
			runOnlyForDeploymentPostprocessing = 0;
		};
/* End PBXSourcesBuildPhase section */

/* Begin PBXVariantGroup section */
		A11EDAD82C4791F4002C79B6 /* LaunchScreen.storyboard */ = {
			isa = PBXVariantGroup;
			children = (
				A11EDAD92C4791F4002C79B6 /* Base */,
			);
			name = LaunchScreen.storyboard;
			sourceTree = "<group>";
		};
/* End PBXVariantGroup section */

/* Begin XCBuildConfiguration section */
		A11EDADC2C4791F4002C79B6 /* Debug */ = {
			isa = XCBuildConfiguration;
			buildSettings = {
				ALWAYS_SEARCH_USER_PATHS = NO;
				ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS = YES;
				CLANG_ANALYZER_NONNULL = YES;
				CLANG_ANALYZER_NUMBER_OBJECT_CONVERSION = YES_AGGRESSIVE;
				CLANG_CXX_LANGUAGE_STANDARD = "gnu++20";
				CLANG_ENABLE_MODULES = YES;
				CLANG_ENABLE_OBJC_ARC = YES;
				CLANG_ENABLE_OBJC_WEAK = YES;
				CLANG_WARN_BLOCK_CAPTURE_AUTORELEASING = YES;
				CLANG_WARN_BOOL_CONVERSION = YES;
				CLANG_WARN_COMMA = YES;
				CLANG_WARN_CONSTANT_CONVERSION = YES;
				CLANG_WARN_DEPRECATED_OBJC_IMPLEMENTATIONS = YES;
				CLANG_WARN_DIRECT_OBJC_ISA_USAGE = YES_ERROR;
				CLANG_WARN_DOCUMENTATION_COMMENTS = YES;
				CLANG_WARN_EMPTY_BODY = YES;
				CLANG_WARN_ENUM_CONVERSION = YES;
				CLANG_WARN_INFINITE_RECURSION = YES;
				CLANG_WARN_INT_CONVERSION = YES;
				CLANG_WARN_NON_LITERAL_NULL_CONVERSION = YES;
				CLANG_WARN_OBJC_IMPLICIT_RETAIN_SELF = YES;
				CLANG_WARN_OBJC_LITERAL_CONVERSION = YES;
				CLANG_WARN_OBJC_ROOT_CLASS = YES_ERROR;
				CLANG_WARN_QUOTED_INCLUDE_IN_FRAMEWORK_HEADER = YES;
				CLANG_WARN_RANGE_LOOP_ANALYSIS = YES;
				CLANG_WARN_STRICT_PROTOTYPES = YES;
				CLANG_WARN_SUSPICIOUS_MOVE = YES;
				CLANG_WARN_UNGUARDED_AVAILABILITY = YES_AGGRESSIVE;
				CLANG_WARN_UNREACHABLE_CODE = YES;
				CLANG_WARN__DUPLICATE_METHOD_MATCH = YES;
				COPY_PHASE_STRIP = NO;
				DEBUG_INFORMATION_FORMAT = dwarf;
				ENABLE_STRICT_OBJC_MSGSEND = YES;
				ENABLE_TESTABILITY = YES;
				ENABLE_USER_SCRIPT_SANDBOXING = YES;
				GCC_C_LANGUAGE_STANDARD = gnu17;
				GCC_DYNAMIC_NO_PIC = NO;
				GCC_NO_COMMON_BLOCKS = YES;
				GCC_OPTIMIZATION_LEVEL = 0;
				GCC_PREPROCESSOR_DEFINITIONS = (
					"DEBUG=1",
					"\$(inherited)",
				);
				GCC_WARN_64_TO_32_BIT_CONVERSION = YES;
				GCC_WARN_ABOUT_RETURN_TYPE = YES_ERROR;
				GCC_WARN_UNDECLARED_SELECTOR = YES;
				GCC_WARN_UNINITIALIZED_AUTOS = YES_AGGRESSIVE;
				GCC_WARN_UNUSED_FUNCTION = YES;
				GCC_WARN_UNUSED_VARIABLE = YES;
				IPHONEOS_DEPLOYMENT_TARGET = 13.0;
				LOCALIZATION_PREFERS_STRING_CATALOGS = YES;
				MTL_ENABLE_DEBUG_INFO = INCLUDE_SOURCE;
				MTL_FAST_MATH = YES;
				ONLY_ACTIVE_ARCH = YES;
				SDKROOT = iphoneos;
				SWIFT_ACTIVE_COMPILATION_CONDITIONS = "DEBUG \$(inherited)";
				SWIFT_OPTIMIZATION_LEVEL = "-Onone";
			};
			name = Debug;
		};
		A11EDADD2C4791F4002C79B6 /* Release */ = {
			isa = XCBuildConfiguration;
			buildSettings = {
				ALWAYS_SEARCH_USER_PATHS = NO;
				ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS = YES;
				CLANG_ANALYZER_NONNULL = YES;
				CLANG_ANALYZER_NUMBER_OBJECT_CONVERSION = YES_AGGRESSIVE;
				CLANG_CXX_LANGUAGE_STANDARD = "gnu++20";
				CLANG_ENABLE_MODULES = YES;
				CLANG_ENABLE_OBJC_ARC = YES;
				CLANG_ENABLE_OBJC_WEAK = YES;
				CLANG_WARN_BLOCK_CAPTURE_AUTORELEASING = YES;
				CLANG_WARN_BOOL_CONVERSION = YES;
				CLANG_WARN_COMMA = YES;
				CLANG_WARN_CONSTANT_CONVERSION = YES;
				CLANG_WARN_DEPRECATED_OBJC_IMPLEMENTATIONS = YES;
				CLANG_WARN_DIRECT_OBJC_ISA_USAGE = YES_ERROR;
				CLANG_WARN_DOCUMENTATION_COMMENTS = YES;
				CLANG_WARN_EMPTY_BODY = YES;
				CLANG_WARN_ENUM_CONVERSION = YES;
				CLANG_WARN_INFINITE_RECURSION = YES;
				CLANG_WARN_INT_CONVERSION = YES;
				CLANG_WARN_NON_LITERAL_NULL_CONVERSION = YES;
				CLANG_WARN_OBJC_IMPLICIT_RETAIN_SELF = YES;
				CLANG_WARN_OBJC_LITERAL_CONVERSION = YES;
				CLANG_WARN_OBJC_ROOT_CLASS = YES_ERROR;
				CLANG_WARN_QUOTED_INCLUDE_IN_FRAMEWORK_HEADER = YES;
				CLANG_WARN_RANGE_LOOP_ANALYSIS = YES;
				CLANG_WARN_STRICT_PROTOTYPES = YES;
				CLANG_WARN_SUSPICIOUS_MOVE = YES;
				CLANG_WARN_UNGUARDED_AVAILABILITY = YES_AGGRESSIVE;
				CLANG_WARN_UNREACHABLE_CODE = YES;
				CLANG_WARN__DUPLICATE_METHOD_MATCH = YES;
				COPY_PHASE_STRIP = NO;
				DEBUG_INFORMATION_FORMAT = "dwarf-with-dsym";
				ENABLE_NS_ASSERTIONS = NO;
				ENABLE_STRICT_OBJC_MSGSEND = YES;
				ENABLE_USER_SCRIPT_SANDBOXING = YES;
				GCC_C_LANGUAGE_STANDARD = gnu17;
				GCC_NO_COMMON_BLOCKS = YES;
				GCC_WARN_64_TO_32_BIT_CONVERSION = YES;
				GCC_WARN_ABOUT_RETURN_TYPE = YES_ERROR;
				GCC_WARN_UNDECLARED_SELECTOR = YES;
				GCC_WARN_UNINITIALIZED_AUTOS = YES_AGGRESSIVE;
				GCC_WARN_UNUSED_FUNCTION = YES;
				GCC_WARN_UNUSED_VARIABLE = YES;
				IPHONEOS_DEPLOYMENT_TARGET = 13.0;
				LOCALIZATION_PREFERS_STRING_CATALOGS = YES;
				MTL_ENABLE_DEBUG_INFO = NO;
				MTL_FAST_MATH = YES;
				SDKROOT = iphoneos;
				SWIFT_COMPILATION_MODE = wholemodule;
				VALIDATE_PRODUCT = YES;
			};
			name = Release;
		};
		A11EDADF2C4791F4002C79B6 /* Debug */ = {
			isa = XCBuildConfiguration;
			buildSettings = {
				ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon;
				ASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME = AccentColor;
				CODE_SIGN_STYLE = Automatic;
				CURRENT_PROJECT_VERSION = 1;
				DEVELOPMENT_TEAM = $DEVELOPMENT_TEAM;
				GENERATE_INFOPLIST_FILE = YES;
				INFOPLIST_FILE = "SANITIZED_NAME/Info.plist";
				INFOPLIST_KEY_UIApplicationSupportsIndirectInputEvents = YES;
				INFOPLIST_KEY_UILaunchStoryboardName = LaunchScreen;
				INFOPLIST_KEY_UISupportedInterfaceOrientations_iPad = "UIInterfaceOrientationPortrait UIInterfaceOrientationPortraitUpsideDown UIInterfaceOrientationLandscapeLeft UIInterfaceOrientationLandscapeRight";
				INFOPLIST_KEY_UISupportedInterfaceOrientations_iPhone = "UIInterfaceOrientationPortrait UIInterfaceOrientationLandscapeLeft UIInterfaceOrientationLandscapeRight";
				LD_RUNPATH_SEARCH_PATHS = (
					"\$(inherited)",
					"@executable_path/Frameworks",
				);
				MARKETING_VERSION = 1.0;
				PRODUCT_BUNDLE_IDENTIFIER = "$ORG_IDENTIFIER.$BUNDLE_ID_NAME";
				PRODUCT_NAME = "\$(TARGET_NAME)";
				SWIFT_EMIT_LOC_STRINGS = YES;
				SWIFT_VERSION = 5.0;
				TARGETED_DEVICE_FAMILY = "1,2";
			};
			name = Debug;
		};
		A11EDAD2C4791F4002C79B6 /* Release */ = {
			isa = XCBuildConfiguration;
			buildSettings = {
				ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon;
				ASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME = AccentColor;
				CODE_SIGN_STYLE = Automatic;
				CURRENT_PROJECT_VERSION = 1;
				DEVELOPMENT_TEAM = $DEVELOPMENT_TEAM;
				GENERATE_INFOPLIST_FILE = YES;
				INFOPLIST_FILE = "SANITIZED_NAME/Info.plist";
				INFOPLIST_KEY_UIApplicationSupportsIndirectInputEvents = YES;
				INFOPLIST_KEY_UILaunchStoryboardName = LaunchScreen;
				INFOPLIST_KEY_UISupportedInterfaceOrientations_iPad = "UIInterfaceOrientationPortrait UIInterfaceOrientationPortraitUpsideDown UIInterfaceOrientationLandscapeLeft UIInterfaceOrientationLandscapeRight";
				INFOPLIST_KEY_UISupportedInterfaceOrientations_iPhone = "UIInterfaceOrientationPortrait UIInterfaceOrientationLandscapeLeft UIInterfaceOrientationLandscapeRight";
				LD_RUNPATH_SEARCH_PATHS = (
					"\$(inherited)",
					"@executable_path/Frameworks",
				);
				MARKETING_VERSION = 1.0;
				PRODUCT_BUNDLE_IDENTIFIER = "$ORG_IDENTIFIER.$BUNDLE_ID_NAME";
				PRODUCT_NAME = "\$(TARGET_NAME)";
				SWIFT_EMIT_LOC_STRINGS = YES;
				SWIFT_VERSION = 5.0;
				TARGETED_DEVICE_FAMILY = "1,2";
			};
			name = Release;
		};
/* End XCBuildConfiguration section */

/* Begin XCConfigurationList section */
		A11EDAC52C4791F2002C79B6 /* Build configuration list for PBXProject "SANITIZED_NAME" */ = {
			isa = XCConfigurationList;
			buildConfigurations = (
				A11EDADC2C4791F4002C79B6 /* Debug */,
				A11EDADD2C4791F4002C79B6 /* Release */,
			);
			defaultConfigurationIsVisible = 0;
			defaultConfigurationName = Release;
		};
		A11EDADE2C4791F4002C79B6 /* Build configuration list for PBXNativeTarget "SANITIZED_NAME" */ = {
			isa = XCConfigurationList;
			buildConfigurations = (
				A11EDADF2C4791F4002C79B6 /* Debug */,
				A11EDAD2C4791F4002C79B6 /* Release */,
			);
			defaultConfigurationIsVisible = 0;
			defaultConfigurationName = Release;
		};
/* End XCConfigurationList section */
	};
	rootObject = A11EDAC22C4791F2002C79B6 /* Project object */;
}
EOF

# Replace SANITIZED_NAME with actual project name in project.pbxproj
sed -i '' "s/SANITIZED_NAME/$SANITIZED_NAME/g" "$SANITIZED_NAME/$SANITIZED_NAME.xcodeproj/project.pbxproj"

# Create contents.xcworkspacedata
cat > "$SANITIZED_NAME/$SANITIZED_NAME.xcodeproj/project.xcworkspace/contents.xcworkspacedata" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<Workspace
   version = "1.0">
   <FileRef
      location = "self:$SANITIZED_NAME.xcodeproj">
   </FileRef>
</Workspace>
EOF

# Create xcscheme
cat > "$SANITIZED_NAME/$SANITIZED_NAME.xcodeproj/xcshareddata/xcschemes/$SANITIZED_NAME.xcscheme" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<Scheme
   LastUpgradeVersion = "1640"
   version = "1.7">
   <BuildAction
      parallelizeBuildables = "YES"
      buildImplicitDependencies = "YES"
      buildArchitectures = "Automatic">
      <BuildActionEntries>
         <BuildActionEntry
            buildForTesting = "YES"
            buildForRunning = "YES"
            buildForProfiling = "YES"
            buildForArchiving = "YES"
            buildForAnalyzing = "YES">
            <BuildableReference
               BuildableIdentifier = "primary"
               BlueprintIdentifier = "4866EAE62E28712200CE3BE0"
               BuildableName = "$SANITIZED_NAME.app"
               BlueprintName = "$SANITIZED_NAME"
               ReferencedContainer = "container:$SANITIZED_NAME.xcodeproj">
            </BuildableReference>
         </BuildActionEntry>
      </BuildActionEntries>
   </BuildAction>
   <TestAction
      buildConfiguration = "Debug"
      selectedDebuggerIdentifier = "Xcode.DebuggerFoundation.Debugger.LLDB"
      selectedLauncherIdentifier = "Xcode.DebuggerFoundation.Launcher.LLDB"
      shouldUseLaunchSchemeArgsEnv = "YES"
      shouldAutocreateTestPlan = "YES">
   </TestAction>
   <LaunchAction
      buildConfiguration = "Debug"
      selectedDebuggerIdentifier = ""
      selectedLauncherIdentifier = "Xcode.IDEFoundation.Launcher.PosixSpawn"
      launchStyle = "0"
      useCustomWorkingDirectory = "NO"
      ignoresPersistentStateOnLaunch = "NO"
      debugDocumentVersioning = "YES"
      debugServiceExtension = "internal"
      allowLocationSimulation = "YES">
      <BuildableProductRunnable
         runnableDebuggingMode = "0">
         <BuildableReference
            BuildableIdentifier = "primary"
            BlueprintIdentifier = "A11EDAC92C4791F2002C79B6"
            BuildableName = "$SANITIZED_NAME.app"
            BlueprintName = "$SANITIZED_NAME"
            ReferencedContainer = "container:$SANITIZED_NAME.xcodeproj">
         </BuildableReference>
      </BuildableProductRunnable>
   </LaunchAction>
   <ProfileAction
      buildConfiguration = "Release"
      shouldUseLaunchSchemeArgsEnv = "YES"
      savedToolIdentifier = ""
      useCustomWorkingDirectory = "NO"
      debugDocumentVersioning = "YES">
      <BuildableProductRunnable
         runnableDebuggingMode = "0">
         <BuildableReference
            BuildableIdentifier = "primary"
            BlueprintIdentifier = "A11EDAC92C4791F2002C79B6"
            BuildableName = "$SANITIZED_NAME.app"
            BlueprintName = "$SANITIZED_NAME"
            ReferencedContainer = "container:$SANITIZED_NAME.xcodeproj">
         </BuildableReference>
      </BuildableProductRunnable>
   </ProfileAction>
   <AnalyzeAction
      buildConfiguration = "Debug">
   </AnalyzeAction>
   <ArchiveAction
      buildConfiguration = "Release"
      revealArchiveInOrganizer = "YES">
   </ArchiveAction>
</Scheme>

EOF

# Create AppDelegate.swift
cat > "$SANITIZED_NAME/$SANITIZED_NAME/AppDelegate.swift" << 'EOF'
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {}
EOF

# Create SceneDelegate.swift
cat > "$SANITIZED_NAME/$SANITIZED_NAME/SceneDelegate.swift" << 'EOF'
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate, UIGestureRecognizerDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        
        let window = UIWindow(windowScene: windowScene)
        let navigationController = UINavigationController(rootViewController: MainViewController())
        navigationController.interactivePopGestureRecognizer?.delegate = self
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        window.backgroundColor = .appBackground
        self.window = window
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return window?.rootViewController?.children.count ?? 0 > 1
    }
    
    /// Allows interactivePopGestureRecognizer to work simultaneously with other gestures.
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        window?.rootViewController?.children.count ?? 0 > 1
    }
    
    /// Blocks other gestures when interactivePopGestureRecognizer begins (my TabView scrolled together with screen swiping back)
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        window?.rootViewController?.children.count ?? 0 > 1
    }
}
EOF

# Create MainView.swift
cat > "$SANITIZED_NAME/$SANITIZED_NAME/Views/MainView.swift" << 'EOF'
import UIKit

class MainView: UIView {
    let title = UILabel()
    
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        title.text = "Hello, World!"
        
        addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        title.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
}

class MainViewController: UIViewController {
    private var mainView: MainView!
    
    override func loadView() {
        view = MainView()
    }
    
    override func viewDidLoad() {
    }
}
EOF

# Create Info.plist
cat > "$SANITIZED_NAME/$SANITIZED_NAME/Info.plist" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>UIApplicationSceneManifest</key>
	<dict>
		<key>UIApplicationSupportsMultipleScenes</key>
		<false/>
		<key>UISceneConfigurations</key>
		<dict>
			<key>UIWindowSceneSessionRoleApplication</key>
			<array>
				<dict>
					<key>UISceneConfigurationName</key>
					<string>Default Configuration</string>
					<key>UISceneDelegateClassName</key>
					<string>$(PRODUCT_MODULE_NAME).SceneDelegate</string>
				</dict>
			</array>
		</dict>
	</dict>
</dict>
</plist>
EOF

# Create LaunchScreen.storyboard
cat > "$SANITIZED_NAME/$SANITIZED_NAME/Base.lproj/LaunchScreen.storyboard" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<document type="com.apple.InterfaceBuilder3.CocoaTouch.Storyboard.XIB" version="3.0" toolsVersion="32700.99.1234" targetRuntime="iOS.CocoaTouch" propertyAccessControl="none" useAutolayout="YES" launchScreen="YES" useTraitCollections="YES" useSafeAreas="YES" colorMatched="YES" initialViewController="01J-lp-oVM">
    <device id="retina6_12" orientation="portrait" appearance="light"/>
    <dependencies>
        <plugIn identifier="com.apple.InterfaceBuilder.IBCocoaTouchPlugin" version="22685"/>
        <capability name="Safe area layout guides" minToolsVersion="9.0"/>
        <capability name="documents saved in the Xcode 8 format" minToolsVersion="8.0"/>
    </dependencies>
    <scenes>
        <!--View Controller-->
        <scene sceneID="EHf-IW-A2E">
            <objects>
                <viewController id="01J-lp-oVM" sceneMemberID="viewController">
                    <view key="view" contentMode="scaleToFill" id="Ze5-6b-2t3">
                        <rect key="frame" x="0.0" y="0.0" width="393" height="852"/>
                        <autoresizingMask key="autoresizingMask" widthSizable="YES" heightSizable="YES"/>
                        <viewLayoutGuide key="safeArea" id="6Tk-OE-BBY"/>
                        <color key="backgroundColor" red="0.086274509803921567" green="0.11764705882352941" blue="0.12549019607843137" alpha="1" colorSpace="custom" customColorSpace="sRGB"/>
                    </view>
                </viewController>
                <placeholder placeholderIdentifier="IBFirstResponder" id="iYj-Kq-Ea1" userLabel="First Responder" sceneMemberID="firstResponder"/>
            </objects>
            <point key="canvasLocation" x="53" y="375"/>
        </scene>
    </scenes>
</document>
EOF

# Create Assets.xcassets Contents.json
cat > "$SANITIZED_NAME/$SANITIZED_NAME/Assets.xcassets/Contents.json" << 'EOF'
{
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}
EOF

# Create AccentColor.colorset Contents.json
cat > "$SANITIZED_NAME/$SANITIZED_NAME/Assets.xcassets/AccentColor.colorset/Contents.json" << 'EOF'
{
  "colors" : [
    {
      "idiom" : "universal"
    }
  ],
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}
EOF

# Create AppBackground.colorset Contents.json
cat > "$SANITIZED_NAME/$SANITIZED_NAME/Assets.xcassets/AppBackground.colorset/Contents.json" << 'EOF'
{
  "colors" : [
    {
      "color" : {
        "color-space" : "srgb",
        "components" : {
          "alpha" : "1.000",
          "blue" : "0.125",
          "green" : "0.118",
          "red" : "0.086"
        }
      },
      "idiom" : "universal"
    },
    {
      "appearances" : [
        {
          "appearance" : "luminosity",
          "value" : "dark"
        }
      ],
      "color" : {
        "color-space" : "srgb",
        "components" : {
          "alpha" : "1.000",
          "blue" : "0.125",
          "green" : "0.118",
          "red" : "0.086"
        }
      },
      "idiom" : "universal"
    }
  ],
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}
EOF

# Create AppIcon.appiconset Contents.json
cat > "$SANITIZED_NAME/$SANITIZED_NAME/Assets.xcassets/AppIcon.appiconset/Contents.json" << 'EOF'
{
  "images" : [
    {
      "idiom" : "universal",
      "platform" : "ios",
      "size" : "1024x1024"
    }
  ],
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}
EOF

cat > "$SANITIZED_NAME/.gitignore" << EOF
UserInterfaceState.xcuserstate
Breakpoints_v2.xcbkptlist
bookmarks.plist
bookmarks.plist
xcschememanagement.plist
*.xcworkspacedata
*.xcscheme
EOF

cd $SANITIZED_NAME
git init
git add .
git commit -a -m init

echo "Successfully created project structure for '$SANITIZED_NAME'"