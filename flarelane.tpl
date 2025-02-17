___TERMS_OF_SERVICE___
This template integrates FlareLane Web SDK with Google Tag Manager.
By using this template, you agree to FlareLane's terms of service.

___INFO___
{
  "type": "TAG",
  "id": "flarelane_gtm_template",
  "version": 1,
  "securityGroups": [],
  "categories": [
    "ANALYTICS",
    "MARKETING"
  ],
  "displayName": "Flarelane Web SDK",
  "description": "Flarelane Web SDK를 Google Tag Manager에서 손쉽게 연동할 수 있도록 지원하는 태그 템플릿.",
  "containerContexts": [
    "WEB"
  ],
  "brand": {
    "thumbnail": "",
    "displayName": "Flarelane",
    "id": "brand_custom_template"
  }
}

___TEMPLATE_PARAMETERS___
[
  {
    "type": "TEXT",
    "name": "projectId",
    "displayName": "FlareLane Project ID",
    "help": "Enter your FlareLane Project ID",
    "defaultValue": "1850566f-1ac9-4248-b0b9-beb93df92d0d"
  },
  {
    "type": "BOOLEAN",
    "name": "enableLogging",
    "displayName": "Enable Debug Logging",
    "help": "Enable logging in the console for debugging purposes.",
    "defaultValue": false
  }
]

___SANDBOXED_JS_FOR_WEB_TEMPLATE___
const log = require('logToConsole');
const injectScript = require('injectScript');
const dataLayer = require('dataLayer');
const getGlobal = require('getGlobal');  // getGlobal을 사용하여 글로벌 변수 접근

const projectId = data.projectId;
const enableLogging = data.enableLogging;

if (!projectId) {
  log('FlareLane Web SDK: Project ID is required.');
  data.gtmOnFailure();
  return;
}

const scriptUrl = "https://cdn.flarelane.com/WebSDK-staging.js";
const global = getGlobal();
const FlareLane = global.FlareLane;  // window 대신 getGlobal()을 통해 접근

// Check if FlareLane SDK is already loaded
if (!FlareLane) {
  injectScript(scriptUrl, function() {
    log('FlareLane Web SDK: Successfully loaded.');

    global.FlareLane = getGlobal().FlareLane;  // 다시 글로벌 객체를 가져옴

    if (global.FlareLane && typeof global.FlareLane.initialize === 'function') {
      global.FlareLane.initialize({ projectId: projectId });

      if (enableLogging) {
        log('FlareLane Web SDK: Initialized with Project ID:', projectId);
      }

      // Push event to the data layer for tracking
      dataLayer.push({ event: 'FlareLaneInitialized', projectId: projectId });

      data.gtmOnSuccess();
    } else {
      log('FlareLane Web SDK: Initialization failed - FlareLane object not found.');
      data.gtmOnFailure();
    }
  });
} else {
  log('FlareLane Web SDK: Already loaded.');
  data.gtmOnSuccess();
}