import React from "react";
import {Composition} from "remotion";
import {FlashcardsExplainer} from "./FlashcardsExplainer";
import {FPS, OUTPUT_HEIGHT, OUTPUT_WIDTH, TOTAL_FRAMES} from "./timeline";

export const RemotionRoot: React.FC = () => {
  return (
    <Composition
      id="FlashcardsExplainer"
      component={FlashcardsExplainer}
      durationInFrames={TOTAL_FRAMES}
      fps={FPS}
      width={OUTPUT_WIDTH}
      height={OUTPUT_HEIGHT}
    />
  );
};
