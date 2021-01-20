"use strict";

const fs = require("fs");
const path = require("path");

const MAIN_FILE_NAME = "[Reliacode] Monk.lua";
const MAIN_FILE_PATH = path.resolve(process.cwd(), MAIN_FILE_NAME);

const MONK_PATH = path.resolve("./src/Monk.lua");
const MONK_CODE = fs.readFileSync(MONK_PATH, "utf8");

const PROFILE_UI_CODE_PATH = path.resolve("./src/ProfileUI.lua");
const PROFILE_UI_CODE = fs.readFileSync(PROFILE_UI_CODE_PATH, "utf8");

const DYNAMIC_BAR_CODE_PATH = path.resolve("./src/DynamicBar.lua");
const DYNAMIC_BAR_CODE = fs.readFileSync(DYNAMIC_BAR_CODE_PATH, "utf8");

const WINDWALKER_CODE_PATH = path.resolve("./src/Windwalker.lua");
const WINDWALKER_CODE = fs.readFileSync(WINDWALKER_CODE_PATH, "utf8");

const INTERRUPT_CODE_PATH = path.resolve("./src/Interrupts.lua");
const INTERRUPT_CODE = fs.readFileSync(INTERRUPT_CODE_PATH, "utf8");

const PREDICTION_HEALING_CODE_PATH = path.resolve(
  "./src/PredictionHealing.lua"
);
const PREDICTION_HEALING_CODE = fs.readFileSync(
  PREDICTION_HEALING_CODE_PATH,
  "utf8"
);

if (fs.existsSync(MAIN_FILE_PATH)) {
  fs.rmSync(MAIN_FILE_PATH);
}

const finalCode = MONK_CODE.replace(
  /\"\{\{PROFILE_UI_CODE\}\}\"/,
  JSON.stringify(PROFILE_UI_CODE)
)
  .replace(/\"\{\{DYNAMIC_BAR_CODE\}\}\"/, JSON.stringify(DYNAMIC_BAR_CODE))
  .replace(/\"\{\{WINDWALKER_CODE\}\}\"/, JSON.stringify(WINDWALKER_CODE))
  .replace(/\"\{\{INTERRUPT_CODE\}\}\"/, JSON.stringify(INTERRUPT_CODE))
  .replace(
    /\"\{\{PREDICTION_HEALING_CODE\}\}\"/,
    JSON.stringify(PREDICTION_HEALING_CODE)
  );

fs.writeFileSync(MAIN_FILE_PATH, finalCode);

if (!fs.existsSync(MAIN_FILE_PATH)) {
  console.error(`Unable to find built ${MAIN_FILE_PATH}`);
  process.exit(1);
}

const newCode = fs.readFileSync(MAIN_FILE_PATH, "utf8");

if (MONK_CODE === newCode) {
  console.error(`Failed to template ${MAIN_FILE_PATH}`);
  process.exit(1);
}

process.exit(0);
