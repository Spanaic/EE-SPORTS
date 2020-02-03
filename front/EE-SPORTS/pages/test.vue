<template>
  <div class="resize-img">
    <!-- 画像選択 -->
    <!-- v-showでラップして画像選択後はファイルアップロード機能を非表示にする -->
    <div v-show="!resizedImg" class="resize-img__post">
      <label for="file" class="resize-img__post__label">
        画像
        <input id="file" ref="fileInput" accept=".jpeg, .png" type="file" @change="attachImg" />
      </label>
    </div>
    <!-- プレビュー -->
    <!-- プレビュー画像があれば表示する -->
    <div v-show="resizedImg" class="resize-img__preview">
      <div class="resize-img__preview__circle" @click="clearAttachImg">
        <span class="resize-img__preview__circle__close-icon">×</span>
      </div>
      <img :src="resizedImg" class="resize-img__preview__img" />
    </div>
  </div>
</template>

<script>
import loadImage from "blueimp-load-image";

export default {
  data() {
    return {
      resizedImg: null
    };
  },
  destroyed() {
    this.clearAttachImg();
  },
  methods: {
    attachImg(e) {
      const file = e.target.files[0];

      loadImage.parseMetaData(file, data => {
        const options = {
          maxHeight: 1080,
          maxWidth: 1920,
          canvas: true
        };
        if (data.exif) {
          options.orientation = data.exif.get("Orientation");
        }
        this.displayImage(file, options);
      });
    },
    displayImage(file, options) {
      loadImage(
        file,
        async canvas => {
          const data = canvas.toDataURL(file.type);
          //data_url => blob object
          const blob = this.base64ToBlob(data, file.type);
          // objectのURLを生成
          const url = window.URL.createObjectURL(blob);

          this.resizedImg = url; // resizedImgはdataで定義
          console.log(this.resizedImg);
        },
        options
      );
    },
    clearAttachImg() {
      this.resizedImg = null;
      if (this.$refs.fileInput && this.$refs.fileInput.value !== undefined) {
        this.$refs.fileInput.value = "";
        window.URL.revokeObjectURL(this.resizedImg);
      }
    },
    base64ToBlob(base64, fileType) {
      const bin = atob(base64.replace(/^.*,/, ""));
      const buffer = new Uint8Array(bin.length);
      for (let i = 0; i < bin.length; i++) {
        buffer[i] = bin.charCodeAt(i);
      }
      return new Blob([buffer.buffer], {
        type: fileType ? fileType : "image/png"
      });
    }
  }
};
</script>

<style lang="scss" scoped>
.resize-img {
  width: 300px;
  height: 300px;
  margin: 0 auto;
  margin-top: 20px;

  &__post {
    border: 1px solid rgba(#000, 0.16);
    line-height: 30rem;

    &__label {
      display: inline-block;
      width: 100%;
      color: rgba(0, 0, 0, 0.4);
      text-align: center;

      & > input {
        display: none;
      }
    }
  }

  &__preview {
    width: 300px;
    height: 300px;

    &__circle {
      position: absolute;
      right: 37px;
      width: 27px;
      height: 27px;
      margin: 5px;
      padding: 2px 9px;
      border-radius: 50%;
      background-color: rgba(0, 0, 0, 0.3);

      &__close-icon {
        color: #fff;
      }
    }

    &__img {
      width: 100%;
      height: 100%;
      object-fit: cover;
    }
  }
}
</style>