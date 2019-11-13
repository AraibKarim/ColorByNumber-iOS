import UIKit

class TableViewCell: UITableViewCell {

  /*
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        //  gameViewController.touchesBegan(touches, with: event)
        let touch: UITouch = touches.first as! UITouch
        print ("cell",touch.view?.tag)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        //  gameViewController.touchesBegan(touches, with: event)
        let touch: UITouch = touches.first as! UITouch
        print ("cell",touch.view?.tag)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        //  gameViewController.touchesBegan(touches, with: event)
        let touch: UITouch = touches.first as! UITouch
        print ("cell",touch.view?.tag)
    }
  */
    @IBOutlet weak var collectionView: CollectionView!
    
  
}

extension TableViewCell {

    func setCollectionViewDataSourceDelegate<D: UICollectionViewDataSource & UICollectionViewDelegate>(_ dataSourceDelegate: D, forRow row: Int) {

        collectionView.delegate = dataSourceDelegate
        collectionView.dataSource = dataSourceDelegate
        collectionView.tag = row
        collectionView.setContentOffset(collectionView.contentOffset, animated:false) // Stops collection view if it was scrolling.
        collectionView.reloadData()
    }
  

    var collectionViewOffset: CGFloat {
        set { collectionView.contentOffset.x = newValue }
        get { return collectionView.contentOffset.x }
    }
    func setGameViewControllerToCollectionView (gameViewController : GameViewController){
        self.collectionView.tag  = 2
        self.collectionView.gameViewController =  gameViewController
        self.collectionView.register(UINib(nibName: "ColorBoxesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ColorBoxesCollectionViewCell")
          self.collectionView.register(UINib(nibName: "DoneTickTableViewCell", bundle: nil), forCellWithReuseIdentifier: "DoneTickTableViewCell")
        self.collectionView.reloadData()

    }
}
