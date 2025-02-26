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
  }
]

___SANDBOXED_JS_FOR_WEB_TEMPLATE___
const log = require('logToConsole');
const injectScript = require('injectScript');
const getGlobal = require('getGlobal');
const setInWindow = require('setInWindow'); // dataLayer 대신 사용
const copyFromDataLayer = require('copyFromDataLayer'); // dataLayer 데이터를 읽어오기

const projectId = data.projectId;

// Validate projectId
if (!projectId || typeof projectId !== 'string' || projectId.trim() === '') {
  log('FlareLane Web SDK: Invalid Project ID.');
  data.gtmOnFailure();
  return;
}

const scriptUrl = "https://cdn.flarelane.com/WebSDK-staging.js";
const global = getGlobal();

// Check if FlareLane SDK is already loaded
if (!global.FlareLane) {
  injectScript(scriptUrl, function() {
    log('FlareLane Web SDK: Successfully loaded.');

    // Delay to ensure FlareLane is properly initialized

      global.FlareLane = getGlobal().FlareLane;

      if (global.FlareLane && typeof global.FlareLane.initialize === 'function') {
        global.FlareLane.initialize({ projectId: projectId });

      log('FlareLane Web SDK: Initialized with Project ID: ' + projectId);


        // Safe way to push to dataLayer in GTM Sandbox
        let dataLayer = copyFromDataLayer() || [];
        dataLayer.push({ event: 'FlareLaneInitialized', projectId: String(projectId) });
        setInWindow('dataLayer', dataLayer); // Sandbox에서 dataLayer에 값 삽입

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