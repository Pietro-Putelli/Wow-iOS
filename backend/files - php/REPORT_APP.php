<html>
    
    <font face="verdana" size="20"> 
    
    <?php

    require_once 'LocalDB.php';
    require_once 'EventDB.php';
    require_once 'UsersAccountDB.php';

    $id = $_GET['id'];
    $type = $_GET['type'];
    
    switch ($type) {
        
        case 0:
            $local = new LocalDB();
            $local_data = $local->getLocalByID($id);
            echo $local_data->getJSON();
            break;
            
        case 1:
            
            $event = new EventDB();
            $event_data = $event->getEventByID($id);
            echo $event_data->getJSON();
            break;
            
        case 2:
            
            $review = new LocalDB();
            $review_data = $review->getLocalReview($id);
            echo $review_data->getReviewJSON();
            break;
            
        case 3:
            
            $discussion = new EventDB();
            $discussion_data = $discussion->getEventDiscussionByID($id);
            echo $discussion_data->getDiscussionJSON();
            break;
            
        case 4:
            
            $reply = new EventDB();
            $reply_data = $reply->getDiscussionAnswer($id);
            echo $reply_data->getDiscussionJSON();
            break;
            
        case 5:
            
            $user = new UsersAccountDB();
            $user_data = $user->getUserDataByID_JSON($id);
            echo json_encode($user_data);
            break;

        default: break;
    }
    
    ?>
    
    </font>
    
    </html>