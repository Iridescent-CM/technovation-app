<template>
  <a href="#" @click.prevent="openJudgeRecusalForm(judgeRecusalCount, maximumNumberOfRecusals)" :class="cssClass">
    <slot></slot>
  </a>
</template>

<script>
import Swal from 'sweetalert2'
import { mapState } from 'vuex'

export default {
  computed: {
    ...mapState(['score'])
  },

  props: {
    cssClass: {
      type: String,
      default: ''
    },
    judgeRecusalCount: {
      type: Number,
      default: 0
    },
    maximumNumberOfRecusals: {
      type: String,
      default: 0
    }
  },

  methods: {
    async openJudgeRecusalForm (judgeRecusalCount, maximumNumberOfRecusals) {
      const { value: formValues } = await Swal.fire({
        title: 'What is the reason you cannot judge this submission?',
        html: `
          <div id="judge-recusal-form">
            <div>
              <input type="radio" id="not-in-english" name="judge-recusal-reason" value="submission_not_in_english" checked>
              <label for="not-in-english">The submission is not in English</label>
            </div>
            <div>
              <input type="radio" id="knows-team" name="judge-recusal-reason" value="knows_team">
              <label for="knows-team">I know this team or mentor</label>
            </div>
            <div>
              <input type="radio" id="other" name="judge-recusal-reason" value="other">
              <label for="other">Other</label>
              <textarea id="judge-recusal-comment"></textarea>
              <div id="character-div"><span id="character-count">0</span>/50 words</div>
            </div>

          </div>
        `,
        footer: `
          <p>${judgeRecusalCount} out of ${maximumNumberOfRecusals} recusals used</p>
          <p id="last-recusal">${(judgeRecusalCount == maximumNumberOfRecusals - 1) ? "This will be your last recusal!" : ""}</p>
        `,
        willOpen:() =>{
          let characterCount = 0;
          const commentBoxEl = document.querySelector('#judge-recusal-comment');
          const characterCountEl = document.querySelector('#character-count');

          commentBoxEl.addEventListener('keyup',() =>{
            Swal.resetValidationMessage();
            let currentCommentText = commentBoxEl.value.trim();

            if(currentCommentText !== ""){
              characterCount = currentCommentText.split(" ").length;
            } else {
              characterCount = 0;
            }

            characterCountEl.innerHTML = characterCount.toString();

          });
        },
        preConfirm: () => {
          const judgeRecusalReason = document.querySelector('input[name="judge-recusal-reason"]:checked').value
          const judgeRecusalComment = document.getElementById('judge-recusal-comment').value
          const judgeRecusalCommentWordCount = judgeRecusalComment.trim().split(" ").length

          if (judgeRecusalReason === 'other' && judgeRecusalComment.trim() === '') {
            Swal.showValidationMessage('Please add a reason for recusing yourself. Comment must be at least 3 words.')
          } else if (judgeRecusalReason === 'other' && judgeRecusalCommentWordCount < 3 || judgeRecusalCommentWordCount > 50){
            Swal.showValidationMessage('Comment must be between 3 and 50 words')
          } else if ( judgeRecusalReason !== 'other' && judgeRecusalComment.trim() !== '' && judgeRecusalCommentWordCount < 3 || judgeRecusalCommentWordCount > 50) {
            Swal.showValidationMessage('Comment must be between 3 and 50 words')
          }

          return { judgeRecusalReason, judgeRecusalComment }
        },
        confirmButtonText: 'Remove me from this submission',
        confirmButtonColor: '#3FA428',
        showCancelButton: true,
        cancelButtonText: 'I want to go back and try judging',
        focusConfirm: false,
        reverseButtons: true,
        width: '45%'
      })

      if (formValues) {
        await window.axios.patch(`/judge/scores/${this.score.id}/judge_recusal`, {
          submission_score: {
            judge_recusal_reason: formValues.judgeRecusalReason,
            judge_recusal_comment: formValues.judgeRecusalComment
          }
        })

        window.location.href = '/judge/dashboard'
      }
    }
  }
}
</script>

<style lang="scss">
#judge-recusal-form {
  display: flex;
  flex-flow: column wrap;
  align-items: flex-start;
  align-content: space-evenly;
  margin-top: 1rem;

  div {
    margin-bottom: .3rem;
    text-align: left;
  }

  #character-div, #character-div span {
    font-size: 10pt;
  }

  #judge-recusal-comment {
    display: inline;
    width: 100%;
    padding: .2rem;
    margin-top: .4rem;
    margin-bottom: .4rem;
  }

  #character-div{
    justify-content: flex-end;
    display: flex;
    width: 50%;
    float: right;
  }
}

.swal2-content, .swal2-actions {
  width: 100%;
}

.swal2-actions button.swal2-confirm,
.swal2-actions button.swal2-cancel {
  font-weight: 100;
}

.swal2-popup .swal2-footer {
  flex-direction: column;
  align-items: center;
  padding: 0;
  margin: 0;

  p {
    font-size: 10pt;
    font-style: italic;
    color: #6b7280;
  }

  p#last-recusal {
    color: #4b5563;
    font-weight: 700;
  }
}
</style>
