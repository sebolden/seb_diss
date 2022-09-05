from psaw import PushshiftAPI
import math
import json
import requests
import itertools
import numpy as np
import time
from datetime import datetime, timedelta
import pandas as pd
from pathlib import Path
import prawcore
from prawcore.exceptions import Forbidden
import praw



reddit = praw.Reddit(user_agent='diss research 1.0 by /u/Okie-Wait'
                         , client_id='CLIENT-ID'
                         , client_secret='CLIENT-SECRET')

###################################################################################################



def getUserPosts():
    TIMEOUT_AFTER_COMMENT_IN_SECS = .350

    commentDict = {"op_id": [],
                    "comment_id": [],
                    "target_comment_id": [],
                    "post_id": [],
                    "comment_utc": [],
                    "score": [],
                    "body": [],
                    "is_submitter": [],
                    "stickied": [],
                    "edited": [],
                    "comment_karma": [],
                    "link_karma": [],
                    "account_created_utc": [],
                    "is_employee": [],
                    "is_mod": []}
    
    commentFail = {"fail_type": [],
                   "fail_id": []}

    ids = ['ID1', 'ID2', 'IDX']

    for i in ids: 
        
        TIMEOUT_AFTER_COMMENT_IN_SECS = .350
        submission = reddit.submission(id=i)
        submission.comments.replace_more(limit=None)
        
        print("beginning comment collection")

        for comment in submission.comments.list():
            try:
                commentDict['op_id'].append(comment.author.id)
                commentDict['comment_id'].append(comment.id)
                commentDict['target_comment_id'].append(comment.parent_id)
                commentDict['post_id'].append(comment.link_id)
                commentDict['comment_utc'].append(comment.created_utc)
                commentDict['score'].append(comment.score)
                commentDict['body'].append(comment.body)
                commentDict['is_submitter'].append(comment.is_submitter)
                commentDict['stickied'].append(comment.stickied)
                commentDict['edited'].append(comment.edited)
                commentDict['comment_karma'].append(comment.author.comment_karma)
                commentDict['link_karma'].append(comment.author.link_karma)
                commentDict['account_created_utc'].append(comment.author.created_utc)
                commentDict['is_employee'].append(comment.author.is_employee)
                commentDict['is_mod'].append(comment.author.is_mod)
            except prawcore.exceptions.NotFound:
                commentFail["fail_type"].append("NotFound")
                commentFail["fail_id"].append(i)
            except prawcore.exceptions.Forbidden:
                commentFail["fail_type"].append("Forbidden")
                commentFail["fail_id"].append(i)
            except prawcore.exceptions.ResponseException:
                commentFail["fail_type"].append("ResponseException")
                commentFail["fail_id"].append(i)
            except AttributeError:
                commentFail["fail_type"].append("AttributeError")
                commentFail["fail_id"].append(i)
            except praw.errors.APIException:
                commentFail["fail_type"].append("APIException")
                commentFail["fail_id"].append(i)
            else:
                commentFail["fail_type"].append("unknown_failure")
                commentFail["fail_id"].append(i)
            if TIMEOUT_AFTER_COMMENT_IN_SECS > 0:
                time.sleep(TIMEOUT_AFTER_COMMENT_IN_SECS)

        print("comment collection complete")
        print("writing data frame")
        
        commentDF = pd.DataFrame(commentDict)
        output_file_comments = "comments_batch3_" + i + ".csv"
        output_dir_comments = Path('G:/Shared drives/SEB Diss/Data collection/seb_diss/data/reddit/comments/')
        output_dir_comments.mkdir(parents=True, exist_ok=True)
        commentDF.to_csv(output_dir_comments / output_file_comments)
        
        commentFailDF = pd.DataFrame(commentFail)
        output_file_commentFail = "comments_batch3_" + i + "_fail.csv"
        output_dir_commentFail = Path('G:/Shared drives/SEB Diss/Data collection/seb_diss/data/reddit/comments/')
        output_dir_commentFail.mkdir(parents=True, exist_ok=True)
        commentFailDF.to_csv(output_dir_commentFail / output_file_commentFail)


###################################################################################################


getUserPosts()





















